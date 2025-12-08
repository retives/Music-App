import { BASE_API_URL } from '../../store/constants';

export const constants = {
  imageFileMaxSize: 10240,
  fileSizeConversion: 1024,
  playlistNameMinLength: 3,
  playlistNameMaxLength: 50,
  playlistDescriptionMinLength: 3,
  playlistDescriptionMaxLength: 1000,
  API_URL: BASE_API_URL + '/api/v1/my/playlists',
  get_API_URL: BASE_API_URL + '/api/v1/playlists',
  store_URL: BASE_API_URL + '/uploads/store/',
};
