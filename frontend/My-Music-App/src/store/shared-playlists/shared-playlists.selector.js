import { createSelector } from '@reduxjs/toolkit';

const sharedPlaylistsPageSelector = (state) => state.sharedPlaylistsSlice;

export const sharedPlaylistsLoadingSelector = createSelector(
  sharedPlaylistsPageSelector,
  (sharedPlaylistsSlice) => sharedPlaylistsSlice.loading
);

export const sharedPlaylistsSelector = createSelector(
  sharedPlaylistsPageSelector,
  (sharedPlaylistsSlice) => sharedPlaylistsSlice.sharedPlaylists
);

export const sharedPlaylistsMetadataSelector = createSelector(
  sharedPlaylistsPageSelector,
  (sharedPlaylistsSlice) => sharedPlaylistsSlice.metadata
);

export const sharedPlaylistsSongsSelector = createSelector(
  sharedPlaylistsPageSelector,
  (sharedPlaylistsSlice) => sharedPlaylistsSlice.songs
);

export const sharedPlaylistsErrorSelector = createSelector(
  sharedPlaylistsPageSelector,
  (sharedPlaylistsSlice) => sharedPlaylistsSlice.error
);
