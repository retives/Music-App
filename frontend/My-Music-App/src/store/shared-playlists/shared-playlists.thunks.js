import { createAsyncThunk } from '@reduxjs/toolkit';
import {
  FETCH_PLAYLISTS_TYPES,
  MY_PLAYLISTS_URL as SHARED_PLAYLISTS_URL,
} from '../constants';
import { default as makeAxiosRequest } from '../lib/helpers/makeAxiosRequest';

export const fetchSharedPlaylists = createAsyncThunk(
  'sharedPlaylistsSlice/fetchSharedPlaylists',
  async (page, { getState }) => {
    const accessToken = getState().user.accessToken;
    const headersList = {
      Accept: '*/*',
      Authorization: `Bearer ${accessToken}`,
    };
    const reqOptions = {
      url: `${SHARED_PLAYLISTS_URL}?playlist_type=${FETCH_PLAYLISTS_TYPES.SHARED}&page=${page}`,
      method: 'GET',
      headers: headersList,
    };

    return await makeAxiosRequest(reqOptions);
  }
);
export const fetchSharedPlaylistsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchSharedPlaylistsFulfilled = (state, action) => {
  state.loading = false;
  state.sharedPlaylists = action.payload.playlists.data;
  state.metadata = action.payload.metadata;
  state.songs = action.payload.playlists.included;
};
export const fetchSharedPlaylistsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
