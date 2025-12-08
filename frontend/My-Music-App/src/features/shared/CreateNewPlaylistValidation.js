import { constants } from './Constants';

export const validate = (values) => {
  const error = {};
  if (values.playlistLogo) {
    const fileSizeKiloBytes =
      values.playlistLogo.size / constants.fileSizeConversion;
    if (fileSizeKiloBytes > constants.imageFileMaxSize) {
      error.playlistLogo =
        'File size exceeds the maximum allowed. Please select an image which is smaller than 10 MB.';
    }
  }
  if (
    values.playlistName &&
    values.playlistName.length < constants.playlistNameMinLength
  ) {
    error.playlistName =
      'Too short, playlist name should be between 3 and 50 characters in length.';
  } else if (
    values.playlistName &&
    values.playlistName.length > constants.playlistNameMaxLength
  ) {
    error.playlistName =
      'Too big, playlist name should be between 3 and 50 characters in length.';
  }
  if (
    values.description &&
    values.description.length < constants.playlistDescriptionMinLength
  ) {
    error.description =
      'Too short, playlist description should be between 3 and 1000 characters in length.';
  } else if (
    values.description &&
    values.description.length > constants.playlistDescriptionMaxLength
  ) {
    error.description =
      'Too big, playlist description should be between 3 and 1000 characters in length.';
  }
  return error;
};
