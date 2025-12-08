import { createSelector } from '@reduxjs/toolkit';

const myPlaylistsSliceSelector = (state) => state.myPlaylistsSlice;

export const pageOfMyPlaylistsSelector = createSelector(
  myPlaylistsSliceSelector,
  (myPlaylistsSlice) => myPlaylistsSlice.myPlaylists
);

export const shouldRefreshMyPlaylistsSelector = createSelector(
  myPlaylistsSliceSelector,
  (myPlaylistsSlice) => myPlaylistsSlice.shouldRefreshMyPlaylists
);

export const myPlaylistsMetadataPageSelector = createSelector(
  myPlaylistsSliceSelector,
  (myPlaylistsSlice) => myPlaylistsSlice.metadata
);

export const myPlaylistErrorSelector = createSelector(
  myPlaylistsSliceSelector,
  (myPlaylistsSlice) => myPlaylistsSlice.error
);

export const myPlaylistLoadingSelector = createSelector(
  myPlaylistsSliceSelector,
  (myPlaylistsSlice) => myPlaylistsSlice.loading
);
