import numpy as np
from scipy.spatial.distance import cdist


def remove_duplicates_fixed(spike_train, source, sampling_frequency, min_firing_rate=4, max_firing_rate=35,
                            max_duplicate_time_diff=0.01, num_bins=100):
    min_firing_interval = 1 / max_firing_rate
    time_stamp = np.linspace(1 / sampling_frequency, spike_train.shape[0] / sampling_frequency,
                             spike_train.shape[0])

    firings = spike_train.sum(axis=0)
    lower_bound_cond = np.where(firings > min_firing_rate * time_stamp[-1])[0]
    upper_bound_cond = np.where(firings < max_firing_rate * time_stamp[-1])[0]
    plausible_firings = np.intersect1d(lower_bound_cond, upper_bound_cond)

    for k in plausible_firings:
        while True:
            spike_indices = np.flatnonzero(spike_train[:, k] == 1)
            if len(spike_indices) < 2:
                break

            spike_time_diff = np.diff(time_stamp[spike_indices])
            close_pairs = np.flatnonzero(spike_time_diff < min_firing_interval)
            if len(close_pairs) == 0:
                break

            t = close_pairs[0]
            current_idx = spike_indices[t]
            next_idx = spike_indices[t + 1]
            if source[current_idx, k] < source[next_idx, k]:
                spike_train[current_idx, k] = 0
            else:
                spike_train[next_idx, k] = 0

    duplicate_sources = []
    for k in plausible_firings:
        if k not in duplicate_sources:
            for j in np.setdiff1d(plausible_firings[plausible_firings != k], duplicate_sources):
                spike_times_1 = time_stamp[spike_train[:, k] == 1]
                spike_times_2 = time_stamp[spike_train[:, j] == 1]
                hist_1, _ = np.histogram(spike_times_1, bins=num_bins)
                hist_2, _ = np.histogram(spike_times_2, bins=num_bins)
                dist = cdist(hist_1[np.newaxis, :], hist_2[np.newaxis, :], metric='cosine')[0][0]
                if dist < max_duplicate_time_diff:
                    duplicate_sources.append(j)

    good_idx = np.setdiff1d(plausible_firings, duplicate_sources)
    return spike_train[:, good_idx], source[:, good_idx], good_idx


def main():
    n_samples = 1000
    spike_train = np.zeros((n_samples, 1), dtype=int)
    spikes = np.array([100, 110, 120, 500, 800])
    spike_train[spikes, 0] = 1

    source = np.zeros((n_samples, 1), dtype=float)
    source[100, 0] = 0.4
    source[110, 0] = 0.9
    source[120, 0] = 0.2
    source[500, 0] = 0.8
    source[800, 0] = 0.7

    cleaned, _, good_idx = remove_duplicates_fixed(
        spike_train.copy(), source, sampling_frequency=1000, min_firing_rate=1, max_firing_rate=35
    )
    remaining = np.flatnonzero(cleaned[:, 0])
    expected = np.array([110, 500, 800])
    np.testing.assert_array_equal(remaining, expected)
    np.testing.assert_array_equal(good_idx, np.array([0]))
    print('PASS: consecutive close spikes are removed using their real sample indices')
    print('remaining spike indices:', remaining.tolist())


if __name__ == '__main__':
    main()
