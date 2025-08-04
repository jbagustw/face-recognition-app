// jest-dom adds custom jest matchers for asserting on DOM nodes.
// allows you to do things like:
// expect(element).toHaveTextContent(/react/i)
// learn more: https://github.com/testing-library/jest-dom
import '@testing-library/jest-dom';

// Mock face-api.js
jest.mock('face-api.js', () => ({
  nets: {
    tinyFaceDetector: {
      loadFromUri: jest.fn().mockResolvedValue(true)
    },
    faceLandmark68Net: {
      loadFromUri: jest.fn().mockResolvedValue(true)
    },
    faceRecognitionNet: {
      loadFromUri: jest.fn().mockResolvedValue(true)
    },
    faceExpressionNet: {
      loadFromUri: jest.fn().mockResolvedValue(true)
    }
  },
  detectAllFaces: jest.fn().mockResolvedValue([]),
  detectSingleFace: jest.fn().mockResolvedValue(null),
  draw: {
    drawDetections: jest.fn(),
    drawFaceLandmarks: jest.fn()
  },
  matchDimensions: jest.fn(),
  resizeResults: jest.fn().mockReturnValue([]),
  FaceMatcher: jest.fn().mockImplementation(() => ({
    findBestMatch: jest.fn().mockReturnValue({
      label: 'unknown',
      distance: 1
    })
  })),
  LabeledFaceDescriptors: jest.fn().mockImplementation((label, descriptors) => ({
    label,
    descriptors
  }))
}));

// Mock navigator.mediaDevices
Object.defineProperty(navigator, 'mediaDevices', {
  value: {
    getUserMedia: jest.fn().mockResolvedValue({
      getTracks: jest.fn().mockReturnValue([
        { stop: jest.fn() }
      ])
    })
  },
  writable: true
});

// Mock canvas
HTMLCanvasElement.prototype.getContext = jest.fn(() => ({
  clearRect: jest.fn(),
  drawImage: jest.fn()
}));

// Mock video
HTMLVideoElement.prototype.play = jest.fn();
HTMLVideoElement.prototype.pause = jest.fn();
