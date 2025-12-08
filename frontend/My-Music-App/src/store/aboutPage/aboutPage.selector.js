import { createSelector } from '@reduxjs/toolkit';

const aboutPageSliceSelector = (state) => state.aboutPageSlice;

export const aboutPageSelector = createSelector(
  aboutPageSliceSelector,
  (aboutPageSlice) => aboutPageSlice.aboutUs
);
