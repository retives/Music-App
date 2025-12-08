import { createSelector } from '@reduxjs/toolkit';

const homePageSelector = (state) => state.homePageSlice;

export const homePageLoadingSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.loading
);

export const popularPlaylistsSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.popularPlaylists
);

export const popularPlaylistsPaginationSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.popularPlaylistsPaginationData
);

export const featuredPlaylistsSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.featuredPlaylists
);

export const featuredPlaylistsPaginationSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.featuredPlaylistsPaginationData
);

export const latestPlaylistsSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.latestPlaylists
);

export const latestPlaylistsPaginationSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.latestPlaylistsPaginationData
);

export const popularSongsSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.popularSongs
);

export const popularSongsPaginationSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.popularSongsPaginationData
);

export const latestSongsSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.latestSongs
);

export const latestSongsPaginationSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.latestSongsPaginationData
);

export const genresSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.genres
);

export const topGenresSongsSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.topGenresSongs
);

export const topGenresSongsPaginationSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.topGenresSongsPaginationData
);

export const topUsersSelector = createSelector(
  homePageSelector,
  (homePageSlice) => homePageSlice.topUsers
);
