import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './addSongsModal.thunks';

const initialState = {
  loading: false,
  error: null,
  lastPage: 1,
  songs: [],
};

export const addSongsModalSlice = createSlice({
  name: 'addSongsModalSlice',
  initialState: initialState,
  reducers: {
    setAddSongsModal: (state, action) => {
      state.addSongsModal = action.payload;
    },
    removeSongFromList: (state, action) => {
      const id = action.payload;
      state.songs = state.songs.filter((song) => song.id !== id);
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(thunks.findSongs.pending, thunks.findSongsPending)
      .addCase(thunks.findSongs.fulfilled, thunks.findSongsFulfilled)
      .addCase(thunks.findSongs.rejected, thunks.findSongsRejected);
  },
});

export const { setAddSongsModal, removeSongFromList } =
  addSongsModalSlice.actions;

export const addSongsModalReducer = addSongsModalSlice.reducer;
