import { createSelector } from '@reduxjs/toolkit';

const playlistDetailsSliceSelector = (state) => state.playlistDetailsSlice;

export const playlistDetailsSelector = createSelector(
  playlistDetailsSliceSelector,
  (playlistDetailsSlice) => playlistDetailsSlice.playlistDetails
);

export const playlistDetailsLoadingSelector = createSelector(
  playlistDetailsSliceSelector,
  (playlistDetailsSlice) => playlistDetailsSlice.loading
);

export const playlistDetailsErrorSelector = createSelector(
  playlistDetailsSliceSelector,
  (playlistDetailsSlice) => playlistDetailsSlice.error
);
