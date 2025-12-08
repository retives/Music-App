import { createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';
import {
  API_URL,
  FETCH_HOME_PLAYLISTS_TYPES,
  FETCH_USER_TYPES,
  PUBLIC_PLAYLIST_URL,
  SONGS_URL,
} from '../constants';

export const fetchPopularPlaylists = createAsyncThunk(
  'homePageSlice/fetchPopularPlaylists',
  async (page = 1) => {
    try {
      const response = await axios({
        url: `${PUBLIC_PLAYLIST_URL}?type=${FETCH_HOME_PLAYLISTS_TYPES.POPULAR}&page=${page}&per_page=4`,
      });
      return {
        playlists: response.data.playlists.data,
        paginationData: response.data.pagination_metadata,
      };
    } catch ({ response: { data } }) {
      throw data.error ?? data.errors;
    }
  }
);
export const fetchPopularPlaylistsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchPopularPlaylistsFulfilled = (state, action) => {
  state.loading = false;
  state.popularPlaylists = action.payload.playlists;
  state.popularPlaylistsPaginationData = action.payload.paginationData;
};
export const fetchPopularPlaylistsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchFeaturedPlaylists = createAsyncThunk(
  'homePageSlice/fetchFeaturedPlaylists',
  async (page = 1) => {
    try {
      const response = await axios({
        url: `${PUBLIC_PLAYLIST_URL}?type=${FETCH_HOME_PLAYLISTS_TYPES.FEATURED}&page=${page}&per_page=6`,
      });

      return {
        playlists: response.data.playlists.data,
        paginationData: response.data.pagination_metadata,
      };
    } catch ({ response: { data } }) {
      throw data.error ?? data.errors;
    }
  }
);
export const fetchFeaturedPlaylistsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchFeaturedPlaylistsFulfilled = (state, action) => {
  state.loading = false;
  state.featuredPlaylists = action.payload.playlists;
  state.featuredPlaylistsPaginationData = action.payload.paginationData;
};
export const fetchFeaturedPlaylistsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchLatestPlaylists = createAsyncThunk(
  'homePageSlice/fetchLatestPlaylists',
  async (page = 1) => {
    try {
      const response = await axios({
        url: `${PUBLIC_PLAYLIST_URL}?type=${FETCH_HOME_PLAYLISTS_TYPES.LAST}&page=${page}&per_page=6`,
      });
      return {
        playlists: response.data.playlists.data,
        paginationData: response.data.pagination_metadata,
      };
    } catch ({ response: { data } }) {
      throw data.error ?? data.errors;
    }
  }
);
export const fetchLatestPlaylistsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchLatestPlaylistsFulfilled = (state, action) => {
  state.loading = false;
  state.latestPlaylists = action.payload.playlists;
  state.latestPlaylistsPaginationData = action.payload.paginationData;
};
export const fetchLatestPlaylistsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchHomepagePopularSongs = createAsyncThunk(
  'homePageSlice/fetchHomepageSongs',
  async (page = 1) => {
    try {
      const response = await axios({
        url: `${SONGS_URL}?popular=true&page=${page}&per_page=6&sort_order=desc`,
      });
      return {
        songs: response.data.songs.data,
        paginationData: response.data.pagination_metadata,
      };
    } catch ({ response: { data } }) {
      throw data.error ?? data.errors;
    }
  }
);
export const fetchHomepagePopularSongsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchHomepagePopularSongsFulfilled = (state, action) => {
  state.loading = false;
  state.popularSongs = action.payload.songs;
  state.popularSongsPaginationData = action.payload.paginationData;
};
export const fetchHomepagePopularSongsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchHomePageLastSongs = createAsyncThunk(
  'homePageSlice/fetchHomePageLastSongs',
  async (page = 1) => {
    try {
      const response = await axios({
        url: `${SONGS_URL}?sort_by=created_at&sort_order=desc&per_page=6&page=${page}`,
      });
      return {
        songs: response.data.songs.data,
        paginationData: response.data.pagination_metadata,
      };
    } catch ({ response: { data } }) {
      throw data.error ?? data.errors;
    }
  }
);
export const fetchHomePageLastSongsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchHomePageLastSongsFulfilled = (state, action) => {
  state.loading = false;
  state.latestSongs = action.payload.songs;
  state.latestSongsPaginationData = action.payload.paginationData;
};
export const fetchHomePageLastSongsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchHomePageGenres = createAsyncThunk(
  'homePageSlice/fetchHomePageGenres',
  async () => {
    try {
      const response = await axios({
        url: `${API_URL}/genres?top=true&limit=5`,
      });
      return response.data.genres.data;
    } catch ({ response: { data } }) {
      throw data.error ?? data.errors;
    }
  }
);
export const fetchHomePageGenresPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchHomePageGenresFulfilled = (state, action) => {
  state.loading = false;
  state.genres = action.payload;
};
export const fetchHomePageGenresRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchHomePageTopGenresSongs = createAsyncThunk(
  'homePageSlice/fetchHomePageTopGenresSongs',
  async (page = 1) => {
    const perPage = 6;
    const genresCount = 5;
    const limitPerGenre = 2;
    try {
      const response = await axios({
        url: `${API_URL}/songs?genres_count=${genresCount}&limit_per_genre=${limitPerGenre}&sort_order=desc&per_page=${perPage}&page=${page}`,
      });
      return {
        songs: response.data.songs.data,
        paginationData: response.data.pagination_metadata,
      };
    } catch ({ response: { data } }) {
      throw data.error ?? data.errors;
    }
  }
);
export const fetchHomePageTopGenresSongsPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchHomePageTopGenresSongsFulfilled = (state, action) => {
  state.loading = false;
  state.topGenresSongs = action.payload.songs;
  state.topGenresSongsPaginationData = action.payload.paginationData;
};
export const fetchHomePageTopGenresSongsRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};

export const fetchHomePageTopUsers = createAsyncThunk(
  'homePageSlice/fetchTopUsers',
  async () => {
    try {
      const responses = await axios.all([
        axios({
          url: `${API_URL}/users?user_type=${FETCH_USER_TYPES.POPULAR}&per_page=5&page=1`,
        }),
        axios({
          url: `${API_URL}/users?user_type=${FETCH_USER_TYPES.CONTRIBUTOR}&per_page=5&page=1`,
        }),
      ]);
      return {
        popular: responses[0].data.users.data,
        contributor: responses[1].data.users.data,
      };
    } catch ({ response: { data } }) {
      throw data.error ?? data.errors;
    }
  }
);
export const fetchHomePageTopUsersPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchHomePageTopUsersFulfilled = (state, action) => {
  state.loading = false;
  state.topUsers = {
    popular: action.payload.popular,
    contributor: action.payload.contributor.filter(
      ({ attributes: { playlists_number: playlistsNum } }) => !!playlistsNum
    ),
  };
};
export const fetchHomePageTopUsersRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
