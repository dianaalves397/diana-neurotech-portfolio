"""Utilities for the synthetic neural-decoding portfolio project."""

from .data import make_synthetic_population
from .model import evaluate_decoder

__all__ = ["make_synthetic_population", "evaluate_decoder"]
