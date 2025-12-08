import { createSelector } from '@reduxjs/toolkit';

const myAccountSliceSelector = (state) => state.myAccountSlice;

export const myAccountSelector = createSelector(
  myAccountSliceSelector,
  (myAccountSlice) => myAccountSlice.myAccount
);

export const myAccountErrorSelector = createSelector(
  myAccountSliceSelector,
  (myAccountSlice) => myAccountSlice.error
);

export const myAccountLoadingSelector = createSelector(
  myAccountSliceSelector,
  (myAccountSlice) => myAccountSlice.loading
);
