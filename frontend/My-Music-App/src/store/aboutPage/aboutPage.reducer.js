import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './aboutPage.thunks';

const initialState = {
  loading: false,
  error: null,
  aboutUs: {},
};

export const aboutPageSlice = createSlice({
  name: 'aboutPageSlice',
  initialState: initialState,
  reducers: {
    setAboutPage: (state, action) => {
      state.aboutUs = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(thunks.fetchAbout.pending, thunks.fetchAboutPending)
      .addCase(thunks.fetchAbout.fulfilled, thunks.fetchAboutFulfilled)
      .addCase(thunks.fetchAbout.rejected, thunks.fetchAboutRejected);
  },
});

export const { setAboutPage } = aboutPageSlice.actions;

export const aboutPageReducer = aboutPageSlice.reducer;
