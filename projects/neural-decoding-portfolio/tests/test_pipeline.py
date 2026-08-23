from src.neural_decoding import evaluate_decoder, make_synthetic_population


def test_synthetic_population_shape_and_labels():
    X, y = make_synthetic_population(n_trials=120, n_neurons=12, random_state=7)
    assert X.shape == (120, 12)
    assert len(y) == 120
    assert set(y.unique()).issubset({0, 90, 180, 270})
    assert (X.to_numpy() >= 0).all()


def test_decoder_learns_direction_signal():
    X, y = make_synthetic_population(n_trials=600, n_neurons=30, random_state=11)
    result = evaluate_decoder(X, y, random_state=11)
    assert result.accuracy >= 0.70
    assert result.cv_mean >= 0.75
    assert result.confusion_matrix.shape == (4, 4)
