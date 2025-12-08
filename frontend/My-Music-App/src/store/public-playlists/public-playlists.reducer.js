import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './public-playlists.thunks';

const INITIAL_STATE = {
  loading: false,
  error: null,
  publicPlaylists: [],
  songs: [],
  metadata: {},
};

export const publicPlaylistsSlice = createSlice({
  name: 'publicPlaylistsSlice',
  initialState: INITIAL_STATE,
  reducers: {
    setPublicPlaylists: (state, action) => {
      state.publicPlaylists = action.payload;
    },
    setSongs: (state, action) => {
      state.songs = action.payload;
    },
    setMetadata: (state, action) => {
      state.metadata = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(
        thunks.fetchPublicPlaylists.pending,
        thunks.fetchPublicPlaylistsPending
      )
      .addCase(
        thunks.fetchPublicPlaylists.fulfilled,
        thunks.fetchPublicPlaylistsFulfilled
      )
      .addCase(
        thunks.fetchPublicPlaylists.rejected,
        thunks.fetchPublicPlaylistsRejected
      )
      .addCase(
        thunks.fetchFilterPlaylists.pending,
        thunks.fetchFilterPlaylistsPending
      )
      .addCase(
        thunks.fetchFilterPlaylists.fulfilled,
        thunks.fetchFilterPlaylistsFulfilled
      )
      .addCase(
        thunks.fetchFilterPlaylists.rejected,
        thunks.fetchFilterPlaylistsRejected
      )
      .addCase(
        thunks.fetchSortedPlaylists.pending,
        thunks.fetchSortedPlaylistsPending
      )
      .addCase(
        thunks.fetchSortedPlaylists.fulfilled,
        thunks.fetchSortedPlaylistsFulfilled
      )
      .addCase(
        thunks.fetchSortedPlaylists.rejected,
        thunks.fetchSortedPlaylistsRejected
      );
  },
});

export const { setPublicPlaylists, setSongs, setMetadata } =
  publicPlaylistsSlice.actions;

export const publicPlaylistsReducer = publicPlaylistsSlice.reducer;
