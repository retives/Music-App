import { createAsyncThunk } from '@reduxjs/toolkit';
import { PUBLIC_PLAYLIST_URL } from '../constants';
import { default as makeAxiosRequest } from '../lib/helpers/makeAxiosRequest';

export const fetchPublicPlaylists = createAsyncThunk(
  'publicPlaylistsSlice/fetchPublicPlaylists',
  async (page) => {
    const headersList = {
      Accept: '*/*',
    };
    const reqOptions = {
      url: `${PUBLIC_PLAYLIST_URL}?page=${page}&include=songs`,
      method: 'GET',
      headers: headersList,
    };

    const response = await makeAxiosRequest(reqOptions);
    return {
      playlists: response.playlists.data,
      songs: response.playlists.included,
      metadata: response.pagination_metadata,
    };
  }
);
export const fetchPublicPlaylistsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchPublicPlaylistsFulfilled = (state, action) => {
  state.loading = false;
  state.publicPlaylists = action.payload.playlists;
  state.metadata = action.payload.metadata;
  state.songs = action.payload.songs;
};
export const fetchPublicPlaylistsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchFilterPlaylists = createAsyncThunk(
  'publicPlaylistsSlice/fetchFilterPlaylists',
  async ({ page, term }) => {
    const headersList = {
      Accept: '*/*',
    };
    const reqOptions = {
      url: `${PUBLIC_PLAYLIST_URL}?page=${page}&search=${term}&include=songs`,
      method: 'GET',
      headers: headersList,
    };

    const response = await makeAxiosRequest(reqOptions);
    return {
      playlists: response.playlists.data,
      songs: response.playlists.included,
      metadata: response.pagination_metadata,
    };
  }
);

export const fetchFilterPlaylistsPending = (state) => {
  state.loading = true;
  state.error = null;
};

export const fetchFilterPlaylistsFulfilled = (state, action) => {
  state.loading = false;
  state.publicPlaylists = action.payload.playlists;
  state.metadata = action.payload.metadata;
  state.songs = action.payload.songs;
};

export const fetchFilterPlaylistsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchSortedPlaylists = createAsyncThunk(
  'publicPlaylistsSlice/fetchSortedPlaylists',
  async ({ page, sortBy, sortDirection }) => {
    const headersList = {
      Accept: '*/*',
    };
    const reqOptions = {
      url: `${PUBLIC_PLAYLIST_URL}?page=${page}&sort_by=${sortBy}&sort_order=${sortDirection}&include=songs`,
      method: 'GET',
      headers: headersList,
    };

    const response = await makeAxiosRequest(reqOptions);
    return {
      playlists: response.playlists.data,
      songs: response.playlists.included,
      metadata: response.pagination_metadata,
    };
  }
);

export const fetchSortedPlaylistsPending = (state) => {
  state.loading = true;
  state.error = null;
};

export const fetchSortedPlaylistsFulfilled = (state, action) => {
  state.loading = false;
  state.publicPlaylists = action.payload.playlists;
  state.metadata = action.payload.metadata;
  state.songs = action.payload.songs;
};

export const fetchSortedPlaylistsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
