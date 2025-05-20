import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const LoginPage = ({ setLoggedInUser }) => {
  const [username, setUsername] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const navigate = useNavigate();

  const handleLogin = () => {
    if (username === 'Pratik' || username === 'Jaanvi') {
      setLoggedInUser(username); // Set loggedInUser
      navigate('/chat');
    } else {
      setErrorMessage('Invalid username. Please enter "Pratik" or "Jaanvi".');
    }
  };
  

  return (
    <div>
      <h1>Login Page</h1>
      {errorMessage && <p>{errorMessage}</p>}
      <input
        type="text"
        placeholder="Enter your username"
        value={username}
        onChange={(e) => setUsername(e.target.value)}
      />
      <button onClick={handleLogin}>Login</button>
    </div>
  );
};

export default LoginPage;
