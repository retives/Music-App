import { createSelector } from '@reduxjs/toolkit';

const publicPlaylistsPageSelector = (state) => state.publicPlaylistsSlice;

export const publicPlaylistsLoadingSelector = createSelector(
  publicPlaylistsPageSelector,
  (publicPlaylistsSlice) => publicPlaylistsSlice.loading
);

export const publicPlaylistsSelector = createSelector(
  publicPlaylistsPageSelector,
  (publicPlaylistsSlice) => publicPlaylistsSlice.publicPlaylists
);

export const publicPlaylistsMetadataSelector = createSelector(
  publicPlaylistsPageSelector,
  (publicPlaylistsSlice) => publicPlaylistsSlice.metadata
);

export const publicPlaylistsSongsSelector = createSelector(
  publicPlaylistsPageSelector,
  (publicPlaylistsSlice) => publicPlaylistsSlice.songs
);

export const publicPlaylistsErrorSelector = createSelector(
  publicPlaylistsPageSelector,
  (publicPlaylistsSlice) => publicPlaylistsSlice.error
);
