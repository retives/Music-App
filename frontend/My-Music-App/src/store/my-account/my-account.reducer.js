import { createSlice } from '@reduxjs/toolkit';
import * as thunks from './my-account.thunks';

export const initialState = {
  loading: false,
  error: null,
  myAccount: {
    nickname: '',
    email: '',
    profilePicture: null,
  },
};

export const myAccountSlice = createSlice({
  name: 'myAccountSlice',
  initialState: initialState,
  reducers: {
    setMyAccount: (state, action) => {
      state.myAccount = action.payload;
    },
    resetMyAccount: (state) => {
      state.myAccount = initialState.myAccount;
      state.error = initialState.error;
      state.loading = initialState.loading;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(thunks.fetchMyAccount.pending, thunks.fetchMyAccountPending)
      .addCase(thunks.fetchMyAccount.fulfilled, thunks.fetchMyAccountFulfilled)
      .addCase(thunks.fetchMyAccount.rejected, thunks.fetchMyAccountRejected)
      .addCase(thunks.updateMyAccount.pending, thunks.updateMyAccountPending)
      .addCase(
        thunks.updateMyAccount.fulfilled,
        thunks.updateMyAccountFulfilled
      )
      .addCase(thunks.updateMyAccount.rejected, thunks.updateMyAccountRejected)
      .addCase(thunks.deleteMyAccount.pending, thunks.deleteMyAccountPending)
      .addCase(
        thunks.deleteMyAccount.fulfilled,
        thunks.deleteMyAccountFulfilled
      )
      .addCase(thunks.deleteMyAccount.rejected, thunks.deleteMyAccountRejected);
  },
});

export const { setMyAccount, resetMyAccount } = myAccountSlice.actions;

export const myAccountReducer = myAccountSlice.reducer;
