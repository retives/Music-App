import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './myPlaylists.thunks';

const initialState = {
  loading: false,
  error: null,
  shouldRefreshMyPlaylists: false,
  metadata: {},
  myPlaylists: [],
};

export const myPlaylistsSlice = createSlice({
  name: 'myPlaylistsSlice',
  initialState: initialState,
  reducers: {
    setMyPlaylists: (state, action) => {
      state.myPlaylists = action.payload;
    },
    setShouldRefreshMyPlaylists: (state, action) => {
      state.shouldRefreshMyPlaylists = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(
        thunks.fetchPageOfMyPlaylists.pending,
        thunks.fetchPageOfMyPlaylistsPending
      )
      .addCase(
        thunks.fetchPageOfMyPlaylists.fulfilled,
        thunks.fetchPageOfMyPlaylistsFulfilled
      )
      .addCase(
        thunks.fetchPageOfMyPlaylists.rejected,
        thunks.fetchPageOfMyPlaylistsRejected
      )
      .addCase(thunks.deleteMyPlaylist.pending, thunks.deleteMyPlaylistPending)
      .addCase(
        thunks.deleteMyPlaylist.fulfilled,
        thunks.deleteMyPlaylistFulfilled
      )
      .addCase(
        thunks.deleteMyPlaylist.rejected,
        thunks.deleteMyPlaylistRejected
      )
      .addCase(thunks.addMyPlaylist.pending, thunks.addMyPlaylistPending)
      .addCase(thunks.addMyPlaylist.fulfilled, thunks.addMyPlaylistFulfilled)
      .addCase(thunks.addMyPlaylist.rejected, thunks.addMyPlaylistRejected)
      .addCase(thunks.editMyPlaylist.pending, thunks.editMyPlaylistPending)
      .addCase(thunks.editMyPlaylist.fulfilled, thunks.editMyPlaylistFulfilled)
      .addCase(thunks.editMyPlaylist.rejected, thunks.editMyPlaylistRejected);
  },
});

export const { setMyPlaylists, setShouldRefreshMyPlaylists } =
  myPlaylistsSlice.actions;

export const myPlaylistsReducer = myPlaylistsSlice.reducer;
