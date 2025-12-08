import React, { useCallback, useEffect, useRef, useState } from 'react';
import { IoAddSharp, IoSearchSharp } from 'react-icons/io5';
import { PiDotBold } from 'react-icons/pi';
import PropTypes from 'prop-types';
import { useDispatch, useSelector } from 'react-redux';
import { toast } from 'react-toastify';

import { baseToastConfig, OneLineMessage } from '../../shared/Toasts';
import closeLogo from '../../shared/assets/closeLogo.svg';
import { AiOutlineDelete } from 'react-icons/ai';
import {
  addSongToPlaylist,
  deleteSongFromPlaylist,
} from '../../store/playlist-details/playlist-details.thunks';
import {
  playlistDetailsErrorSelector,
  playlistDetailsLoadingSelector,
  playlistDetailsSelector,
} from '../../store/playlist-details/playlist-details.selector';
import { findSongs } from '../../store/addSongsModal/addSongsModal.thunks';
import {
  lastPageSelector,
  listOfSongsSelector,
} from '../../store/addSongsModal/addSongsModal.selector';

import {
  ADD_SONG_ACTION_TYPE as ACTION_TYPE,
  ADD_SONG_TOAST_TEXT as TOAST_TEXT,
} from './constants/constants';

import {
  AddSongIcon,
  AddSongsMain,
  AddSongsTitle,
  CloseButton,
  CrossSvg,
  Header,
  ModalContainer,
  SearchBarIcon,
  SearchBarInput,
  SearchBarWrapper,
  SongArtistInfo,
  SongImg,
  SongImgWrapper,
  SongInfo,
  SongItem,
  SongList,
  SongTitle,
  Title,
  WarningMessage,
} from './AddSongsToPlaylists.styles';
import Pagination from '../../shared/Pagination';
import {
  FALLBACK_TYPES,
  IMAGE_SIZES,
} from '../shared/ImgWrap/constants/constants';

function AddSongsToPlaylists({ options }) {
  const dispatch = useDispatch();
  const { isAddSongModalOpen, onClose, modalPlaylistId } = options;
  const toastId = React.useRef(null);
  const playlistErr = useSelector(playlistDetailsErrorSelector);
  const loading = useSelector(playlistDetailsLoadingSelector);
  const AddSongModalRef = useRef(null);

  useEffect(() => {
    if (isAddSongModalOpen) {
      AddSongModalRef.current.showModal();
    } else {
      AddSongModalRef.current.close();
    }
  }, [isAddSongModalOpen]);

  const { songs: allSongs } = useSelector(playlistDetailsSelector);
  const allSongsIds = allSongs.map(({ id }) => id);
  const songs = useSelector(listOfSongsSelector);
  const [searchSong, setSearchSong] = useState('');
  const [isAddSongCliked, setIsAddSongCliked] = useState(false);
  const [isRemoveSongCliked, setIsRemoveSongCliked] = useState(false);
  const [page, setPage] = useState(1);
  const perPage = 5;
  const last = useSelector(lastPageSelector);

  const handleSearch = (e) => {
    setSearchSong(e.target.value);
  };

  const handleFindSongs = async () => {
    dispatch(findSongs({ page, perPage, searchSong }));
  };

  const postSongsData = (id) => {
    const song = songs.find((song) => song.id === id);
    dispatch(
      addSongToPlaylist({ song_id: id, playlist_id: modalPlaylistId, song })
    );
  };

  useEffect(() => {
    handleFindSongs();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page]);

  const notify = useCallback(() => {
    toastId.current = toast(
      <OneLineMessage message={TOAST_TEXT.PROCESSING} />,
      {
        ...baseToastConfig,
        position: 'top-right',
      }
    );
  }, []);

  const notifyError = useCallback((error, actionType) => {
    const isUnpocessableErrorOccured = error?.message?.includes('422');
    const errorMessage =
      isUnpocessableErrorOccured && actionType === ACTION_TYPE.ADD_SONG
        ? TOAST_TEXT.ADD_ERROR
        : isUnpocessableErrorOccured && actionType === ACTION_TYPE.REMOVE_SONG
        ? TOAST_TEXT.DELETE_ERROR
        : TOAST_TEXT.DEFAULT_ERROR;

    toast.update(toastId.current, {
      type: toast.TYPE.ERROR,
      autoClose: 2000,
      render: <OneLineMessage message={errorMessage} />,
    });
  }, []);

  const notifySuccess = useCallback((actionType) => {
    const successMessage =
      actionType === ACTION_TYPE.ADD_SONG
        ? TOAST_TEXT.SUCCESS_ADD
        : actionType === ACTION_TYPE.REMOVE_SONG
        ? TOAST_TEXT.SUCCESS_DELETE
        : TOAST_TEXT.DEFAULT_ERROR;
    const toastType =
      actionType === ACTION_TYPE.ADD_SONG
        ? toast.TYPE.SUCCESS
        : ACTION_TYPE.REMOVE_SONG
        ? toast.TYPE.INFO
        : toast.TYPE.ERROR;
    toast.update(toastId.current, {
      type: toastType,
      autoClose: 1500,
      render: <OneLineMessage message={successMessage} />,
    });
  }, []);

  useEffect(() => {
    if ((isAddSongCliked || isRemoveSongCliked) && loading) {
      notify();
    }
    if (isAddSongCliked && !loading && playlistErr) {
      notifyError(playlistErr, ACTION_TYPE.ADD_SONG);
      setIsAddSongCliked(false);
    }
    if (isAddSongCliked && !loading && !playlistErr) {
      notifySuccess(ACTION_TYPE.ADD_SONG);
      setIsAddSongCliked(false);
    }
    if (isRemoveSongCliked && !loading && playlistErr) {
      notifyError(playlistErr, ACTION_TYPE.REMOVE_SONG);
      setIsRemoveSongCliked(false);
    }
    if (isRemoveSongCliked && !loading && !playlistErr) {
      notifySuccess(ACTION_TYPE.REMOVE_SONG);
      setIsRemoveSongCliked(false);
    }
  }, [
    isAddSongCliked,
    loading,
    playlistErr,
    notify,
    notifyError,
    notifySuccess,
    isRemoveSongCliked,
  ]);

  const handleAddSong = (id) => () => {
    if (loading) return;
    setIsAddSongCliked(true);
    postSongsData(id);
  };
  const handleSearchSongs = (e) => {
    e.preventDefault();
    setPage(1);
    handleFindSongs();
  };
  const handleRemoveSong = (id) => () => {
    if (loading) return;
    setIsRemoveSongCliked(true);
    dispatch(deleteSongFromPlaylist(id));
  };

  const onPageChange = useCallback(
    (changeDirection) => {
      if (changeDirection === 'left' && page !== 1) {
        setPage(page - 1);
      }
      if (changeDirection === 'right' && page < last) {
        setPage(page + 1);
      }
    },
    [page, last]
  );

  return (
    <ModalContainer
      ref={AddSongModalRef}
      className='addSongsToPlaylistsModal__container'
    >
      <Header className='addsongs-header'>
        <Title>Songs</Title>
        <CloseButton onClick={onClose}>
          <CrossSvg src={closeLogo} alt='button to close modal' />
        </CloseButton>
      </Header>
      <SearchBarWrapper>
        <SearchBarInput
          type='text'
          placeholder='Type something'
          value={searchSong}
          onChange={handleSearch}
        />
        <SearchBarIcon type='submit' onClick={handleSearchSongs}>
          <IoSearchSharp size='24' />
        </SearchBarIcon>
      </SearchBarWrapper>
      <AddSongsMain>
        <AddSongsTitle>
          <p>
            {searchSong ? `Search query - "${searchSong}"` : 'Most Popular'}
          </p>
        </AddSongsTitle>
        <SongList className='addsongs-songlist'>
          {songs &&
            songs.map(
              ({ id, attributes: { cover, title, artists, album } }) => {
                const isSongAlreadyAdded = allSongsIds.includes(id);
                return (
                  <SongItem className='addsong-item' key={id}>
                    <SongImgWrapper className='addsong-song-item-img'>
                      <SongImg
                        srcObj={cover}
                        fallbackType={FALLBACK_TYPES.ALBUM}
                        size={IMAGE_SIZES.SMALL}
                        alt='song preview'
                        className='addsong-song-img'
                      />
                    </SongImgWrapper>
                    <SongArtistInfo>
                      <SongTitle>
                        <p>{title}</p>
                      </SongTitle>
                      <SongInfo>
                        <p>{album}</p>
                        <PiDotBold />
                        <p>{artists.join(', ')}</p>
                      </SongInfo>
                    </SongArtistInfo>
                    <AddSongIcon>
                      {isSongAlreadyAdded ? (
                        <AiOutlineDelete
                          className='addsong-item-already-added'
                          onClick={handleRemoveSong(id)}
                        />
                      ) : (
                        <IoAddSharp
                          className='addsong-item-icon'
                          onClick={handleAddSong(id)}
                        />
                      )}
                    </AddSongIcon>
                  </SongItem>
                );
              }
            )}
          {songs.length === 0 && (
            <WarningMessage>There is nothing left...</WarningMessage>
          )}
        </SongList>
        {last !== 1 && (
          <Pagination
            handleClick={onPageChange}
            isLeftActive={!loading && page !== 1}
            isRightActive={!loading && page < last}
            marginBottom='0'
          />
        )}
      </AddSongsMain>
    </ModalContainer>
  );
}

AddSongsToPlaylists.propTypes = {
  options: PropTypes.shape({
    isAddSongModalOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    modalPlaylistId: PropTypes.string,
  }).isRequired,
};

export default AddSongsToPlaylists;
