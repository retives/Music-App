import { createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';
import { ABOUT_US_URL } from '../constants';

export const fetchAbout = createAsyncThunk(
  'aboutPageSlice/fetchAbout',
  async () => {
    try {
      const response = await axios({
        url: ABOUT_US_URL,
        method: 'GET',
        headers: {
          Accept: '*/*',
        },
      });
      return response.data;
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const fetchAboutPending = (state) => {
  state.loading = true;
  state.error = null;
};
export const fetchAboutFulfilled = (state, action) => {
  state.loading = false;
  state.aboutUs = action.payload.option.data.attributes.body;
};
export const fetchAboutRejected = (state, action) => {
  state.loading = false;
  state.error = action.error.message;
};
