import { createSelector } from '@reduxjs/toolkit';

const userPlaylistsReactionsSliceSelector = (state) =>
  state.userPlaylistsReactionsSlice;

export const userPlaylistsReactionsSelector = createSelector(
  userPlaylistsReactionsSliceSelector,
  (userPlaylistsReactionsSlice) =>
    userPlaylistsReactionsSlice.playlistsReactions
);

export const userPlaylistsReactionsLoadingSelector = createSelector(
  userPlaylistsReactionsSliceSelector,
  (userPlaylistsReactionsSlice) => userPlaylistsReactionsSlice.loading
);

export const userPlaylistsReactionsErrorSelector = createSelector(
  userPlaylistsReactionsSliceSelector,
  (userPlaylistsReactionsSlice) => userPlaylistsReactionsSlice.error
);
