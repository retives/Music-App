import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  isBackgroundBlur: false,
};

export const appSlice = createSlice({
  name: 'appSlice',
  initialState,
  reducers: {
    setBackgroundBlur: (state, action) => {
      state.isBackgroundBlur = action.payload;
    },
    toggleBackgroundBlur: (state) => {
      state.isBackgroundBlur = !state.isBackgroundBlur;
    },
  },
});

export const { setBackgroundBlur, toggleBackgroundBlur } = appSlice.actions;

export const appReducer = appSlice.reducer;
