import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './homePage.thunks';

const initialState = {
  loading: false,
  error: null,
  popularPlaylists: [],
  popularPlaylistsPaginationData: {},
  featuredPlaylists: [],
  featuredPlaylistsPaginationData: {},
  latestPlaylists: [],
  latestPlaylistsPaginationData: {},
  popularSongs: [],
  popularSongsPaginationData: {},
  latestSongs: [],
  latestSongsPaginationData: {},
  genres: [],
  topGenresSongs: [],
  topGenresSongsPaginationData: {},
  topUsers: {
    popular: [],
    contributor: [],
  },
};

export const homePageSlice = createSlice({
  name: 'homePageSlice',
  initialState: initialState,
  reducers: {
    setPopularPlaylists: (state, action) => {
      state.popularPlaylists = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(
        thunks.fetchPopularPlaylists.pending,
        thunks.fetchPopularPlaylistsPending
      )
      .addCase(
        thunks.fetchPopularPlaylists.fulfilled,
        thunks.fetchPopularPlaylistsFulfilled
      )
      .addCase(
        thunks.fetchPopularPlaylists.rejected,
        thunks.fetchPopularPlaylistsRejected
      )
      .addCase(
        thunks.fetchFeaturedPlaylists.pending,
        thunks.fetchFeaturedPlaylistsPending
      )
      .addCase(
        thunks.fetchFeaturedPlaylists.fulfilled,
        thunks.fetchFeaturedPlaylistsFulfilled
      )
      .addCase(
        thunks.fetchFeaturedPlaylists.rejected,
        thunks.fetchFeaturedPlaylistsRejected
      )
      .addCase(
        thunks.fetchLatestPlaylists.pending,
        thunks.fetchLatestPlaylistsPending
      )
      .addCase(
        thunks.fetchLatestPlaylists.fulfilled,
        thunks.fetchLatestPlaylistsFulfilled
      )
      .addCase(
        thunks.fetchLatestPlaylists.rejected,
        thunks.fetchLatestPlaylistsRejected
      )
      .addCase(
        thunks.fetchHomepagePopularSongs.pending,
        thunks.fetchHomepagePopularSongsPending
      )
      .addCase(
        thunks.fetchHomepagePopularSongs.fulfilled,
        thunks.fetchHomepagePopularSongsFulfilled
      )
      .addCase(
        thunks.fetchHomepagePopularSongs.rejected,
        thunks.fetchHomepagePopularSongsRejected
      )
      .addCase(
        thunks.fetchHomePageLastSongs.pending,
        thunks.fetchHomePageLastSongsPending
      )
      .addCase(
        thunks.fetchHomePageLastSongs.fulfilled,
        thunks.fetchHomePageLastSongsFulfilled
      )
      .addCase(
        thunks.fetchHomePageLastSongs.rejected,
        thunks.fetchHomePageLastSongsRejected
      )
      .addCase(
        thunks.fetchHomePageGenres.pending,
        thunks.fetchHomePageGenresPending
      )
      .addCase(
        thunks.fetchHomePageGenres.fulfilled,
        thunks.fetchHomePageGenresFulfilled
      )
      .addCase(
        thunks.fetchHomePageGenres.rejected,
        thunks.fetchHomePageGenresRejected
      )
      .addCase(
        thunks.fetchHomePageTopGenresSongs.pending,
        thunks.fetchHomePageTopGenresSongsPending
      )
      .addCase(
        thunks.fetchHomePageTopGenresSongs.fulfilled,
        thunks.fetchHomePageTopGenresSongsFulfilled
      )
      .addCase(
        thunks.fetchHomePageTopGenresSongs.rejected,
        thunks.fetchHomePageTopGenresSongsRejected
      )
      .addCase(
        thunks.fetchHomePageTopUsers.pending,
        thunks.fetchHomePageTopUsersPending
      )
      .addCase(
        thunks.fetchHomePageTopUsers.fulfilled,
        thunks.fetchHomePageTopUsersFulfilled
      )
      .addCase(
        thunks.fetchHomePageTopUsers.rejected,
        thunks.fetchHomePageTopUsersRejected
      );
  },
});

export const { setPopularPlaylists } = homePageSlice.actions;
export const homePageReducer = homePageSlice.reducer;
