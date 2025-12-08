import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './shared-playlists.thunks';

const INITIAL_STATE = {
  loading: false,
  error: null,
  sharedPlaylists: [],
  songs: [],
  metadata: {},
};

export const sharedPlaylistsSlice = createSlice({
  name: 'sharedPlaylistsSlice',
  initialState: INITIAL_STATE,
  reducers: {
    setSharedPlaylists: (state, action) => {
      state.sharedPlaylists = action.payload;
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
        thunks.fetchSharedPlaylists.pending,
        thunks.fetchSharedPlaylistsPending
      )
      .addCase(
        thunks.fetchSharedPlaylists.fulfilled,
        thunks.fetchSharedPlaylistsFulfilled
      )
      .addCase(
        thunks.fetchSharedPlaylists.rejected,
        thunks.fetchSharedPlaylistsRejected
      );
  },
});

export const { setSharedPlaylists, setSongs, setMetadata } =
  sharedPlaylistsSlice.actions;

export const sharedPlaylistsReducer = sharedPlaylistsSlice.reducer;
