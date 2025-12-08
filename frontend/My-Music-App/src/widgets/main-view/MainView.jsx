import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';

import Pagination from '../../shared/Pagination';
import PlaylistsPopular from '../../entities/main-view/playlists-popular/ui/PlaylistsPopular';
import PlaylistsSmall from '../../entities/main-view/playlists-small/ui/PlaylistsSmall';
import Songslist from '../../entities/main-view/songlist/ui/Songslist';
import Genres from '../../entities/main-view/genres/ui/Genres';

import {
  popularPlaylistsSelector,
  featuredPlaylistsSelector,
  latestPlaylistsSelector,
  popularPlaylistsPaginationSelector,
  featuredPlaylistsPaginationSelector,
  latestPlaylistsPaginationSelector,
  homePageLoadingSelector,
  popularSongsSelector,
  popularSongsPaginationSelector,
  latestSongsSelector,
  latestSongsPaginationSelector,
  genresSelector,
  topGenresSongsSelector,
  topGenresSongsPaginationSelector,
  topUsersSelector,
} from '../../store/homePage/homePage.selector';

import {
  fetchPopularPlaylists,
  fetchFeaturedPlaylists,
  fetchLatestPlaylists,
  fetchHomepagePopularSongs,
  fetchHomePageLastSongs,
  fetchHomePageGenres,
  fetchHomePageTopGenresSongs,
  fetchHomePageTopUsers,
} from '../../store/homePage/homePage.thunks';
import TopUsersList from '../../entities/main-view/top-users/ui/TopUsersList';
import { TOP_USERS_TEXT_FIELD_TYPE } from '../../entities/main-view/top-users/constants/constants';

function Main() {
  const dispatch = useDispatch();
  const loading = useSelector(homePageLoadingSelector);
  const playlistsPopular = useSelector(popularPlaylistsSelector);
  const popularPagination = useSelector(popularPlaylistsPaginationSelector);
  const playlistsFeatured = useSelector(featuredPlaylistsSelector);
  const featuredPagination = useSelector(featuredPlaylistsPaginationSelector);
  const playlistsLatest = useSelector(latestPlaylistsSelector);
  const latestPagination = useSelector(latestPlaylistsPaginationSelector);
  const songsPopular = useSelector(popularSongsSelector);
  const songsPopularPagination = useSelector(popularSongsPaginationSelector);
  const songLatest = useSelector(latestSongsSelector);
  const songLatestPagination = useSelector(latestSongsPaginationSelector);
  const genres = useSelector(genresSelector);
  const topGenresSongs = useSelector(topGenresSongsSelector);
  const topGenresSongsPagination = useSelector(
    topGenresSongsPaginationSelector
  );
  const topUsers = useSelector(topUsersSelector);
  const isTopUsersEmpty =
    !topUsers?.popular.length && !topUsers?.contributor.length;

  const handlePaginationClick = (fetcher, pagination) => (direction) => {
    dispatch(
      fetcher(direction === 'left' ? pagination.page - 1 : pagination.page + 1)
    );
  };

  useEffect(() => {
    dispatch(fetchPopularPlaylists());
    dispatch(fetchFeaturedPlaylists());
    dispatch(fetchLatestPlaylists());
    dispatch(fetchHomepagePopularSongs());
    dispatch(fetchHomePageLastSongs());
    dispatch(fetchHomePageGenres());
    dispatch(fetchHomePageTopGenresSongs());
    dispatch(fetchHomePageTopUsers());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []); // Dispatch is not a dependency, it remains unchanged from the initialization of store.

  return (
    <>
      <PlaylistsPopular
        playlists={playlistsPopular}
        className='main-view__playlists--popular'
      />
      <Pagination
        handleClick={handlePaginationClick(
          fetchPopularPlaylists,
          popularPagination
        )}
        isLeftActive={!loading && popularPagination.page > 1}
        isRightActive={
          !loading && popularPagination.page < popularPagination.last
        }
        className='main-view__pagination--playlists-popular'
      />
      <PlaylistsSmall
        subtitle='Featured'
        playlists={playlistsFeatured}
        className='main-view__playlists--featured'
      />
      <Pagination
        handleClick={handlePaginationClick(
          fetchFeaturedPlaylists,
          featuredPagination
        )}
        isLeftActive={!loading && featuredPagination.page > 1}
        isRightActive={
          !loading && featuredPagination.page < featuredPagination.last
        }
        className={'main-view__pagination--playlists-featured'}
      />
      <PlaylistsSmall
        subtitle='Latest'
        playlists={playlistsLatest}
        className='main-view__playlists--latest'
      />
      <Pagination
        handleClick={handlePaginationClick(
          fetchLatestPlaylists,
          latestPagination
        )}
        isLeftActive={!loading && latestPagination.page > 1}
        isRightActive={
          !loading && latestPagination.page < latestPagination.last
        }
        className='main-view__pagination--playlists-latest'
      />
      <Songslist
        title='Songs'
        subtitle='Most popular'
        songs={songsPopular}
        className='main-view__songslist--popular'
      />
      <Pagination
        handleClick={handlePaginationClick(
          fetchHomepagePopularSongs,
          songsPopularPagination
        )}
        isLeftActive={!loading && songsPopularPagination.page > 1}
        isRightActive={
          !loading && songsPopularPagination.page < songsPopularPagination.last
        }
        className='main-view__pagination--song-popular'
      />
      <Songslist
        subtitle='Latest added'
        songs={songLatest}
        className='main-view__songslist--latest'
      />
      <Pagination
        handleClick={handlePaginationClick(
          fetchHomePageLastSongs,
          songLatestPagination
        )}
        isLeftActive={!loading && songLatestPagination.page > 1}
        isRightActive={
          !loading && songLatestPagination.page < songLatestPagination.last
        }
        className='main-view__pagination--song-latest'
      />
      <Genres genres={genres} className='main-view__genres' />
      <Songslist
        subtitle='Top for 5 most popular genres'
        songs={topGenresSongs}
        className='main-view__songslist--top-genres'
      />
      <Pagination
        handleClick={handlePaginationClick(
          fetchHomePageTopGenresSongs,
          topGenresSongsPagination
        )}
        isLeftActive={!loading && topGenresSongsPagination.page > 1}
        isRightActive={
          !loading &&
          topGenresSongsPagination.page < topGenresSongsPagination.last
        }
        className='main-view__pagination--song-top-genres'
      />
      <TopUsersList
        title={isTopUsersEmpty ? null : 'Users'}
        subtitle='Most Popular'
        textFieldType={TOP_USERS_TEXT_FIELD_TYPE.FRIENDS}
        usersList={topUsers?.popular}
      />
      <TopUsersList
        subtitle='Top Contributors'
        usersList={topUsers?.contributor}
        textFieldType={TOP_USERS_TEXT_FIELD_TYPE.PLAYLISTS}
      />
    </>
  );
}

export default Main;
