import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './user-playlists-reactions.thunks';

const INITIAL_STATE = {
  loading: false,
  error: null,
  playlistsReactions: [],
};

export const userPlaylistsReactionsSlice = createSlice({
  name: 'userPlaylistsReactionsSlice',
  initialState: INITIAL_STATE,
  reducers: {
    setPlaylistsReactions: (state, action) => {
      state.playlistsReactions = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(
        thunks.fetchPlaylistsReactions.pending,
        thunks.fetchPlaylistsReactionsPending
      )
      .addCase(
        thunks.fetchPlaylistsReactions.fulfilled,
        thunks.fetchPlaylistsReactionsFulfilled
      )
      .addCase(
        thunks.fetchPlaylistsReactions.rejected,
        thunks.fetchPlaylistsReactionsRejected
      );
  },
});

export const { setPlaylistsReactions } = userPlaylistsReactionsSlice.actions;

export const userPlaylistsReactionsReducer =
  userPlaylistsReactionsSlice.reducer;
