import React, { useCallback, useEffect, useState } from 'react';
import { AiFillPlusCircle, AiOutlineSearch } from 'react-icons/ai';
import { toast } from 'react-toastify';
import './maincontainermyplaylists.css';
import { useDispatch, useSelector } from 'react-redux';
import { errorSelector, userSelector } from '../../store/user/user.selector';
import {
  myPlaylistsMetadataPageSelector,
  myPlaylistErrorSelector,
  myPlaylistLoadingSelector,
  shouldRefreshMyPlaylistsSelector,
  pageOfMyPlaylistsSelector,
} from '../../store/myPlaylists/myPlaylists.selector';
import {
  addMyPlaylist,
  fetchPageOfMyPlaylists,
} from '../../store/myPlaylists/myPlaylists.thunks';
import { setShouldRefreshMyPlaylists } from '../../store/myPlaylists/myPlaylists.reducer';
import {
  Container,
  ContentWrapper,
  InputWrapper,
} from '../public-playlists/PublicPLaylists.styles';
import Header from '../../shared/ui/header/Header';
import InputComponent from '../../shared/ui/input/Input';
import MyPlaylistsList from '../../entities/my-playlists/ui/my-playlists-list/MyPlaylistsList';
import { baseToastConfig, OneLineMessage } from '../../shared/Toasts';
import ModalForm from '../../features/my-playlists/ModalForm';
import Pagination from '../../shared/Pagination';

function MyPlaylists() {
  const dispatch = useDispatch();
  const { isAuthenticated } = useSelector(userSelector);
  const error = useSelector(errorSelector);
  const toastId = React.useRef(null);
  const myPlaylists = useSelector(pageOfMyPlaylistsSelector);

  const playlistErr = useSelector(myPlaylistErrorSelector);
  const loading = useSelector(myPlaylistLoadingSelector);
  const { last, page } = useSelector(myPlaylistsMetadataPageSelector);
  const [isCreatePlaylistCliked, setIsCreatePlaylistCliked] = useState(false);
  const shouldRefreshMyPlaylists = useSelector(
    shouldRefreshMyPlaylistsSelector
  );

  const handleFetch = (page = 1) => {
    dispatch(fetchPageOfMyPlaylists(page));
  };
  useEffect(() => {
    if (!isAuthenticated) return;
    handleFetch();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (!isAuthenticated || !shouldRefreshMyPlaylists) return;
    if (myPlaylists.length === 1 && page !== 1) {
      handleFetch(page - 1);
    } else {
      handleFetch(page);
    }
    dispatch(setShouldRefreshMyPlaylists(false));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [shouldRefreshMyPlaylists]);

  useEffect(() => {
    if (error) console.error(error);
  }, [error]);

  // TODO: Shoud we implement search functionality? There is no endpoint for it
  const [searchString, setSearchString] = useState('');
  const notify = useCallback(() => {
    toastId.current = toast(
      <OneLineMessage message='Creating playlist...' />,
      baseToastConfig
    );
  }, []);

  const notifyError = useCallback(() => {
    toast.update(toastId.current, {
      type: toast.TYPE.ERROR,
      autoClose: 2000,
      render: (
        <OneLineMessage message='Oops, looks like something went wrong.' />
      ),
    });
  }, []);

  const notifySuccess = useCallback(() => {
    toast.update(toastId.current, {
      type: toast.TYPE.SUCCESS,
      autoClose: 2000,
      render: <OneLineMessage message='Playlist successfully created :)' />,
    });
  }, []);

  useEffect(() => {
    if (isCreatePlaylistCliked && loading) {
      notify();
    }
    if (isCreatePlaylistCliked && !loading && playlistErr) {
      notifyError();
      setIsCreatePlaylistCliked(false);
    }
    if (isCreatePlaylistCliked && !loading && !playlistErr) {
      notifySuccess();
      setIsCreatePlaylistCliked(false);
    }
  }, [
    isCreatePlaylistCliked,
    loading,
    playlistErr,
    notify,
    notifyError,
    notifySuccess,
  ]);

  const [isModalFormOpen, setIsModalFormOpen] = useState(false);

  const handleOpenForm = () => setIsModalFormOpen(true);

  const handleCloseForm = () => setIsModalFormOpen(false);

  const handlerCreatePlaylist = ({ formData }) => {
    setIsCreatePlaylistCliked(true);
    dispatch(addMyPlaylist(formData));
  };

  const handleSearchStringChange = (e) => {
    const newSearchString = e.target.value;
    setSearchString(newSearchString.trim().toLowerCase());
  };

  const onPageChange = useCallback(
    (changeDirection) => {
      if (changeDirection === 'left' && page !== 1) {
        handleFetch(page - 1);
      } else if (changeDirection === 'right' && page < last) {
        handleFetch(page + 1);
      }
    },
    // eslint-disable-next-line
    [page, last]
  );

  return (
    <>
      <Container>
        {isModalFormOpen && (
          <ModalForm
            className='modal__create-playlist'
            options={{
              isModalFormOpen,
              onAction: handlerCreatePlaylist,
              onClose: handleCloseForm,
              modalPlaylistId: null,
              playlist: null,
              modalTitle: 'Create playlist',
              actionButtonText: 'Create',
            }}
          />
        )}
        <ContentWrapper>
          <Header title='My Playlists' />
          <InputWrapper>
            <InputComponent
              type={'search'}
              placeholder={'Type something'}
              name={'search-bar'}
              onChange={handleSearchStringChange}
              data-input-id='search-bar'
            />
            <AiOutlineSearch
              className='search-bar-icon'
              data-search-id='search-bar-icon'
            />
          </InputWrapper>
          <div className='newplaylist-wrapper'>
            <AiFillPlusCircle
              onClick={handleOpenForm}
              data-testid='newplaylist-btn'
              className='newplaylist-btn'
            />
            <div className='newplaylist-txt'>New playlist</div>
          </div>
          <div className='division' />
          <MyPlaylistsList searchString={searchString} />
          <Pagination
            handleClick={onPageChange}
            isLeftActive={!loading && page !== 1}
            isRightActive={!loading && page < last}
          />
        </ContentWrapper>
      </Container>
    </>
  );
}

export default MyPlaylists;
