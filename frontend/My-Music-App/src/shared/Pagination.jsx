import React from 'react';
import PropTypes from 'prop-types';
import { PaginationControls } from './Pagination.styles';
import { BsArrowLeftShort, BsArrowRightShort } from 'react-icons/bs';

function Pagination({
  handleClick,
  isLeftActive = false,
  isRightActive = false,
  className,
  marginBottom = '36px',
}) {
  return (
    <PaginationControls $marginBottom={marginBottom} className={className}>
      <button
        disabled={!isLeftActive}
        onClick={() => handleClick('left')}
        data-left-arrow-id='pagination-left-arrow'
      >
        <BsArrowLeftShort />
      </button>
      <button
        disabled={!isRightActive}
        onClick={() => handleClick('right')}
        data-right-arrow-id='pagination-right-arrow'
      >
        <BsArrowRightShort />
      </button>
    </PaginationControls>
  );
}

Pagination.propTypes = {
  handleClick: PropTypes.func,
  isLeftActive: PropTypes.bool,
  isRightActive: PropTypes.bool,
  className: PropTypes.string,
  marginBottom: PropTypes.string,
};

export default Pagination;
