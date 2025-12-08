import { createSelector } from '@reduxjs/toolkit';

const addSongsModalSliceSelector = (state) => state.addSongsModalSlice;

export const listOfSongsSelector = createSelector(
  addSongsModalSliceSelector,
  (addSongsModalSlice) => addSongsModalSlice.songs
);

export const addSongsModalErrorSelector = createSelector(
  addSongsModalSliceSelector,
  (addSongsModalSlice) => addSongsModalSlice.error
);

export const addSongsModalLoadingSelector = createSelector(
  addSongsModalSliceSelector,
  (addSongsModalSlice) => addSongsModalSlice.loading
);

export const lastPageSelector = createSelector(
  addSongsModalSliceSelector,
  (addSongsModalSlice) => addSongsModalSlice.lastPage
);
