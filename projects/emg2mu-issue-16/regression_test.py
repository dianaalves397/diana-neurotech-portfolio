import numpy as np


def clean_close_spikes_original(spike_train, source, sampling_frequency=1000, max_firing_rate=35):
    """Exact close-spike loop from emg2mu main as inspected on 2026-08-23."""
    min_firing_interval = 1 / max_firing_rate
    time_stamp = np.linspace(1 / sampling_frequency, spike_train.shape[0] / sampling_frequency,
                             spike_train.shape[0])
    plausible_firings = np.array([0])
    for k in plausible_firings:
        spike_time_diff = np.diff(time_stamp[spike_train[:, k] == 1])
        for t in range(len(spike_time_diff)):
            if spike_time_diff[t] < min_firing_interval:
                if source[t, k] < source[t + 1, k]:
                    spike_train[t, k] = 0
                else:
                    spike_train[t + 1, k] = 0
    return spike_train


def clean_close_spikes_fixed(spike_train, source, sampling_frequency=1000, max_firing_rate=35):
    min_firing_interval = 1 / max_firing_rate
    time_stamp = np.linspace(1 / sampling_frequency, spike_train.shape[0] / sampling_frequency,
                             spike_train.shape[0])
    plausible_firings = np.array([0])
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
    return spike_train


def fixture():
    spike_train = np.zeros((1000, 1), dtype=int)
    spike_train[[100, 110, 120, 500, 800], 0] = 1
    source = np.zeros((1000, 1), dtype=float)
    source[100, 0] = 0.4
    source[110, 0] = 0.9
    source[120, 0] = 0.2
    source[500, 0] = 0.8
    source[800, 0] = 0.7
    return spike_train, source


if __name__ == '__main__':
    spikes, source = fixture()
    original = clean_close_spikes_original(spikes.copy(), source)
    fixed = clean_close_spikes_fixed(spikes.copy(), source)
    original_remaining = np.flatnonzero(original[:, 0])
    fixed_remaining = np.flatnonzero(fixed[:, 0])
    expected = np.array([110, 500, 800])

    print('original remaining:', original_remaining.tolist())
    print('fixed remaining:   ', fixed_remaining.tolist())
    print('expected:          ', expected.tolist())
    assert not np.array_equal(original_remaining, expected), 'Regression fixture unexpectedly passes old code'
    np.testing.assert_array_equal(fixed_remaining, expected)
    print('PASS: regression reproduced and fixed behavior verified')
