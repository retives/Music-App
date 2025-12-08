import { createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';
import { SONGS_URL } from '../constants';

export const findSongs = createAsyncThunk(
  'addSongsModalSlice/findSongs',
  async (data, { getState }) => {
    const { page, perPage, searchSong } = data;
    const accessToken = getState().user.accessToken;
    try {
      const response = await axios({
        url: SONGS_URL,
        method: 'GET',
        params: {
          page,
          per_page: perPage,
          search: searchSong,
          include: 'album',
        },
        headers: {
          Accept: '*/*',
          Authorization: `Bearer ${accessToken}`,
        },
      });
      return response.data;
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const findSongsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const findSongsFulfilled = (state, action) => {
  state.loading = false;
  state.songs = action.payload.songs.data;
  state.lastPage = action.payload.pagination_metadata.last;
};
export const findSongsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
