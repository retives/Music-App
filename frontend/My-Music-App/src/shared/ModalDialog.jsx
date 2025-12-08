import { React, useRef, useEffect } from 'react';
import PropTypes from 'prop-types';

import {
  ModalContainer,
  Title,
  Divider,
  ActionButton,
  CancelButton,
} from './ModalDialog.styles';

/** Modal dialog component to confirm the song removal
 *
 * @param {boolean} isModalOpen Current state of the modal
 * @param {function} onAction Callback to handle desired action
 * @param {function} onClose Callback to close the modal
 * @param {string} title Title of the modal
 * @param {string} actionButtonText Text to display on the action button
 * @param {string} closeButtonText Text to display on the close button
 */
function ModalDialog({ options, className }) {
  const {
    isModalOpen,
    title,
    actionButtonText,
    closeButtonText,
    onAction,
    onClose,
  } = options;

  const dialogRef = useRef(null); // dialog reference

  // monitoring isOpen prop to open/close the modal dialog
  useEffect(() => {
    if (isModalOpen) {
      dialogRef.current.showModal();
    } else {
      dialogRef.current.close();
    }
  }, [isModalOpen]);

  // handlers
  const handleAction = () => {
    onAction();
    onClose();
  };
  const handleClose = () => {
    onClose();
  };

  return (
    <ModalContainer ref={dialogRef} className={className ?? ``}>
      <Title>{title}</Title>
      <Divider />
      <ActionButton onClick={handleAction}>
        {`${actionButtonText}`}
      </ActionButton>
      <CancelButton onClick={handleClose}>{`${closeButtonText}`}</CancelButton>
    </ModalContainer>
  );
}

ModalDialog.propTypes = {
  options: PropTypes.shape({
    isModalOpen: PropTypes.bool.isRequired,
    onAction: PropTypes.func.isRequired,
    onClose: PropTypes.func.isRequired,
    actionButtonText: PropTypes.string.isRequired,
    closeButtonText: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
  }).isRequired,
  className: PropTypes.string,
};

export default ModalDialog;
