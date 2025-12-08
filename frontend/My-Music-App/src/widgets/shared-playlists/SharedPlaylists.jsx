import React, { useCallback, useEffect, useState } from 'react';

import { useDispatch, useSelector } from 'react-redux';
import { fetchSharedPlaylists } from '../../store/shared-playlists/shared-playlists.thunks';
import {
  sharedPlaylistsErrorSelector,
  sharedPlaylistsLoadingSelector,
  sharedPlaylistsMetadataSelector,
} from '../../store/shared-playlists/shared-playlists.selector';

import Header from '../../shared/ui/header/Header';
import SharedPlaylistList from '../../entities/shared-playlists/ui/shared-playlist-list/SharedPlaylistList';
import Pagination from '../../shared/Pagination';

import {
  Container,
  ContentWrapper,
  InputWrapper,
  NoPlaylistsMessage,
} from '../public-playlists/PublicPLaylists.styles';
import {
  isAuthenticatedSelector,
  userSelector,
} from '../../store/user/user.selector';
import InputComponent from '../../shared/ui/input/Input';
import { AiOutlineSearch } from 'react-icons/ai';
import { fetchPlaylistsReactions } from '../../store/user-playlists-reactions/user-playlists-reactions.thunks';
import { userPlaylistsReactionsSelector } from '../../store/user-playlists-reactions/user-playlists-reactions.selector';

function SharedPlaylists() {
  const dispatch = useDispatch();
  const error = useSelector(sharedPlaylistsErrorSelector);
  const loading = useSelector(sharedPlaylistsLoadingSelector);
  const { last, count: playlistsCount } = useSelector(
    sharedPlaylistsMetadataSelector
  );
  const isAuth = useSelector(isAuthenticatedSelector);
  const { loading: userIsLoading, isRehydrated: userIsRehydrated } =
    useSelector(userSelector);
  const userPlaylistsReactions = useSelector(userPlaylistsReactionsSelector);

  const [page, setPage] = useState(1);
  const [term, setTerm] = useState('');
  const onSearch = (e) => {
    const newTerm = e.target.value;
    setTerm(newTerm.trim().toLowerCase());
  };

  useEffect(() => {
    if (!isAuth) return;
    dispatch(fetchSharedPlaylists(page));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, isAuth]); // Dispatch is not a dependency, it remains unchanged from the initialization of store.

  useEffect(() => {
    if (error) console.error(error);
  }, [error]);

  useEffect(() => {
    if (
      !isAuth ||
      !userIsRehydrated ||
      userIsLoading ||
      userPlaylistsReactions.length !== 0
    )
      return;
    dispatch(fetchPlaylistsReactions());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isAuth, userIsRehydrated, userIsLoading, userPlaylistsReactions.length]);

  const onPageChange = useCallback(
    (changeDirection) => {
      if (changeDirection === 'left' && page !== 1) {
        setPage(page - 1);
      } else if (changeDirection === 'right' && page < last) {
        setPage(page + 1);
      }
    },
    [page, last]
  );

  return (
    <>
      {isAuth && ( // is displayed for all auth users
        <Container>
          <ContentWrapper>
            <Header title={'Shared Playlists'}></Header>
            <InputWrapper>
              <InputComponent
                type={'search'}
                placeholder={'Type something'}
                name={'search-bar'}
                onChange={onSearch}
                value={term}
                data-input-id='search-bar'
              />
              <AiOutlineSearch
                className='search-bar-icon'
                data-search-id='search-bar-icon'
              />
            </InputWrapper>
            <SharedPlaylistList className='shared-playlists' term={term} />
            {playlistsCount === 0 ? (
              <NoPlaylistsMessage>
                There are no playlists yet
              </NoPlaylistsMessage>
            ) : (
              <Pagination
                handleClick={onPageChange}
                isLeftActive={!loading && page !== 1}
                isRightActive={!loading && page < last}
                marginBottom={'12px'}
              />
            )}
          </ContentWrapper>
        </Container>
      )}
    </>
  );
}

export default SharedPlaylists;
