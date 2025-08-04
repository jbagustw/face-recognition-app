import { render, screen } from '@testing-library/react';
import App from './App';

test('renders face recognition app title', () => {
  render(<App />);
  const titleElement = screen.getByText(/Face Recognition System/i);
  expect(titleElement).toBeInTheDocument();
});

test('renders camera controls', () => {
  render(<App />);
  const cameraButton = screen.getByText(/Nyalakan Kamera/i);
  expect(cameraButton).toBeInTheDocument();
});

test('renders sidebar navigation', () => {
  render(<App />);
  const detectionButton = screen.getByText(/Deteksi Wajah/i);
  const registrationButton = screen.getByText(/Registrasi Wajah/i);
  const attendanceButton = screen.getByText(/Kehadiran/i);
  const databaseButton = screen.getByText(/Database/i);

  expect(detectionButton).toBeInTheDocument();
  expect(registrationButton).toBeInTheDocument();
  expect(attendanceButton).toBeInTheDocument();
  expect(databaseButton).toBeInTheDocument();
});
