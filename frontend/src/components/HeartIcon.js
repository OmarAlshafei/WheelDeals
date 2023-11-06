import React, { useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faHeart, faHeart as faHeartOutline } from '@fortawesome/free-solid-svg-icons';

const HeartIcon = () => {
  const [isFilled, setIsFilled] = useState(false);

  const toggleFilled = () => {
    setIsFilled(!isFilled);
  };

  return (
    <td onClick={toggleFilled} style={{ cursor: 'pointer' }}>
      <FontAwesomeIcon
        icon={isFilled ? faHeart : faHeartOutline}
        style={{
          color: isFilled ? '#ff0000' : '#ccc',
          fontSize: '24px', 
        }}
      />
    </td>
  );
};

export default HeartIcon;
