import { useCallback, useEffect, useState } from 'react';

import { useDispatch, useSelector } from 'react-redux';
import {
  fetchFilterPlaylists,
  fetchPublicPlaylists,
  fetchSortedPlaylists,
} from '../../store/public-playlists/public-playlists.thunks';
import {
  publicPlaylistsErrorSelector,
  publicPlaylistsLoadingSelector,
  publicPlaylistsMetadataSelector,
} from '../../store/public-playlists/public-playlists.selector';

import { AiOutlineSearch } from 'react-icons/ai';
import { CgSortAz } from 'react-icons/cg';
import { Tooltip } from 'react-tooltip';

import Header from '../../shared/ui/header/Header';
import InputComponent from '../../shared/ui/input/Input';
import PublicPlaylistList from '../../entities/public-playlists/ui/public-playlist-list/PublicPlaylistList';
import Pagination from '../../shared/Pagination';

import {
  Container,
  ContentWrapper,
  InputWrapper,
  NoPlaylistsMessage,
  SortPlaylistsMenu,
  SortPlaylistsMenuOption,
} from './PublicPLaylists.styles';
import { userSelector } from '../../store/user/user.selector';
import { fetchPlaylistsReactions } from '../../store/user-playlists-reactions/user-playlists-reactions.thunks';
import { userPlaylistsReactionsSelector } from '../../store/user-playlists-reactions/user-playlists-reactions.selector';

function PublicPlaylists() {
  const dispatch = useDispatch();
  const error = useSelector(publicPlaylistsErrorSelector);
  const loading = useSelector(publicPlaylistsLoadingSelector);
  const { last, count: playlistsCount } = useSelector(
    publicPlaylistsMetadataSelector
  );
  const {
    isAuthenticated: userIsAuth,
    loading: userIsLoading,
    isRehydrated: userIsRehydrated,
  } = useSelector(userSelector);
  const userPlaylistsReactions = useSelector(userPlaylistsReactionsSelector);

  const [page, setPage] = useState(1);
  const [term, setTerm] = useState('');
  const [sortParams, setSortParams] = useState({
    page,
    sortBy: '',
    sortDirection: '',
  });
  const [isSortOpen, setIsSortOpen] = useState(false);

  useEffect(() => {
    dispatch(fetchPublicPlaylists(page));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page]); // Dispatch is not a dependency, it remains unchanged from the initialization of store.

  useEffect(() => {
    dispatch(fetchSortedPlaylists(sortParams));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sortParams]); // Same as above

  useEffect(() => {
    if (error) console.error(error);
  }, [error]);

  useEffect(() => {
    if (
      !userIsAuth ||
      !userIsRehydrated ||
      userIsLoading ||
      userPlaylistsReactions.length !== 0
    )
      return;
    dispatch(fetchPlaylistsReactions());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    userIsAuth,
    userIsRehydrated,
    userIsLoading,
    userPlaylistsReactions.length,
  ]);
  const onSearch = () => {
    dispatch(fetchFilterPlaylists({ page, term }));
  };

  const handleSearchByEnterKey = (event) => {
    if (event.key === 'Enter') {
      onSearch();
    }
  };

  const onSort = (event) => {
    switch (event.target.value) {
      case 'playlist-name-asc':
        setSortParams({
          ...sortParams,
          sortBy: 'playlist_name',
          sortDirection: 'asc',
        });
        break;
      case 'playlist-name-desc':
        setSortParams({
          ...sortParams,
          sortBy: 'playlist_name',
          sortDirection: 'desc',
        });
        break;
      case 'comments-count-asc':
        setSortParams({
          ...sortParams,
          sortBy: 'comments_count',
          sortDirection: 'asc',
        });
        break;
      case 'comments-count-desc':
        setSortParams({
          ...sortParams,
          sortBy: 'comments_count',
          sortDirection: 'desc',
        });
        break;
      default:
        break;
    }
  };

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
      {/* TODO: Splice Container+ContentWrapper */}
      <Container>
        <ContentWrapper>
          <Header title={'Public Playlists'}></Header>
          <InputWrapper>
            <InputComponent
              type={'search'}
              placeholder={'Type something'}
              name={'search-bar'}
              onChange={(e) => setTerm(e.target.value)}
              onKeyUp={handleSearchByEnterKey}
              value={term}
              data-input-id='search-bar'
            />
            <AiOutlineSearch
              className='search-bar-icon'
              onClick={onSearch}
              data-search-id='search-bar-icon'
            />
            <div
              className={`sort-icon-wrapper ${isSortOpen ? 'sort-open' : ''}`}
              onMouseEnter={() => setIsSortOpen(true)}
              data-sort-id='sort-icon'
            >
              <CgSortAz
                className={`search-bar-icon sort-icon ${
                  isSortOpen ? 'sort-open' : ''
                }`}
              ></CgSortAz>
            </div>
            <Tooltip
              id='sortMenu'
              anchorSelect='.sort-icon-wrapper'
              place='bottom-end'
              clickable
              closeOnEsc={true}
              isOpen={isSortOpen}
              setIsOpen={setIsSortOpen}
              opacity={1}
              offset={6}
              className='tooltip'
              render={() => (
                <SortPlaylistsMenu
                  id='sort-playlists'
                  name='sort-playlists'
                  onClick={onSort}
                >
                  <p className='sort-group-name'>Name of playlist</p>
                  <SortPlaylistsMenuOption className='sort-menu_option'>
                    <input
                      type='radio'
                      id='playlist-name-asc'
                      name='sort-options'
                      value='playlist-name-asc'
                    />
                    <label
                      htmlFor='playlist-name-asc'
                      className='checkbox-label'
                    >
                      A - Z
                    </label>
                  </SortPlaylistsMenuOption>
                  <SortPlaylistsMenuOption className='sort-menu_option'>
                    <input
                      type='radio'
                      id='playlist-name-desc'
                      name='sort-options'
                      value='playlist-name-desc'
                    />
                    <label
                      htmlFor='playlist-name-desc'
                      className='checkbox-label'
                    >
                      Z - A
                    </label>
                  </SortPlaylistsMenuOption>
                  <p className='sort-group-name'>Comments</p>
                  <SortPlaylistsMenuOption className='sort-menu_option'>
                    <input
                      type='radio'
                      id='comments-count-asc'
                      name='sort-options'
                      value='comments-count-asc'
                    />
                    <label
                      htmlFor='comments-count-asc'
                      className='checkbox-label'
                    >
                      Least comments
                    </label>
                  </SortPlaylistsMenuOption>
                  <SortPlaylistsMenuOption className='sort-menu_option'>
                    <input
                      type='radio'
                      id='comments-count-desc'
                      name='sort-options'
                      value='comments-count-desc'
                    />
                    <label
                      htmlFor='comments-count-desc'
                      className='checkbox-label'
                    >
                      Most comments
                    </label>
                  </SortPlaylistsMenuOption>
                </SortPlaylistsMenu>
              )}
            ></Tooltip>
          </InputWrapper>
          <PublicPlaylistList />
          {playlistsCount === 0 ? (
            <NoPlaylistsMessage>There are no playlists yet</NoPlaylistsMessage>
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
    </>
  );
}

export default PublicPlaylists;
