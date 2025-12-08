import { createSelector } from '@reduxjs/toolkit';

const appSelector = (state) => state.appSlice;

export const backgroundBlurSelector = createSelector(
  appSelector,
  (appSlice) => appSlice.isBackgroundBlur
);
