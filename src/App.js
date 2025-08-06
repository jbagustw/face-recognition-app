import { useState, useEffect, useRef, useCallback } from 'react';
import * as faceapi from 'face-api.js';
import { Camera, Users, Menu, X, CheckCircle, AlertCircle, UserPlus, Clock, Database } from 'lucide-react';
import ApiService from './services/api';

function App() {
  const [isModelLoaded, setIsModelLoaded] = useState(false);
  const [isCameraOn, setIsCameraOn] = useState(false);
  const [currentMode, setCurrentMode] = useState('detection'); // 'detection', 'registration', 'attendance'
  const [registeredFaces, setRegisteredFaces] = useState([]);
  const [attendanceLog, setAttendanceLog] = useState([]);
  const [currentPerson, setCurrentPerson] = useState(null);
  const [isProcessing, setIsProcessing] = useState(false);
  const [showSidebar, setShowSidebar] = useState(false);
  const [newPersonName, setNewPersonName] = useState('');
  const [detectionConfidence, setDetectionConfidence] = useState(0.6);
  const [modelLoadingError, setModelLoadingError] = useState(null);
  const [isLoadingData, setIsLoadingData] = useState(false);
  const [apiError, setApiError] = useState(null);

  const videoRef = useRef();
  const canvasRef = useRef();
  const streamRef = useRef();
  const detectionIntervalRef = useRef();

  // Load faces from database
  const loadFacesFromDatabase = useCallback(async () => {
    setIsLoadingData(true);
    setApiError(null);
    try {
      const faces = await ApiService.getAllFaces();
      
      // Convert database format back to face-api.js format
      const labeledFaceDescriptors = faces.map(face => {
        const descriptors = Array.isArray(face.descriptors) ? face.descriptors : [face.descriptors];
        return new faceapi.LabeledFaceDescriptors(face.label, descriptors);
      });
      
      setRegisteredFaces(labeledFaceDescriptors);
      console.log(`Loaded ${labeledFaceDescriptors.length} faces from database`);
    } catch (error) {
      console.error('Error loading faces from database:', error);
      setApiError('Failed to load faces from database. Using offline mode.');
    } finally {
      setIsLoadingData(false);
    }
  }, []);

  // Load attendance from database
  const loadAttendanceFromDatabase = useCallback(async () => {
    try {
      const attendance = await ApiService.getAttendanceLog();
      setAttendanceLog(attendance);
      console.log(`Loaded ${attendance.length} attendance records from database`);
    } catch (error) {
      console.error('Error loading attendance from database:', error);
    }
  }, []);

  // Load face-api models from CDN
  useEffect(() => {
    const loadModels = async () => {
      try {
        setModelLoadingError(null);
        const MODEL_URL = 'https://justadudewhohacks.github.io/face-api.js/models';

        await Promise.all([
          faceapi.nets.tinyFaceDetector.loadFromUri(MODEL_URL),
          faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL),
          faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL),
          faceapi.nets.faceExpressionNet.loadFromUri(MODEL_URL)
        ]);
        setIsModelLoaded(true);
        console.log('Models loaded successfully');
        
        // Load data from database after models are loaded
        await loadFacesFromDatabase();
        await loadAttendanceFromDatabase();
      } catch (error) {
        console.error('Error loading models:', error);
        setModelLoadingError('Failed to load face recognition models. Please check your internet connection and try again.');
      }
    };

    loadModels();
  }, [loadFacesFromDatabase, loadAttendanceFromDatabase]);

  // Start camera
  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: {
          width: { ideal: 640 },
          height: { ideal: 480 },
          facingMode: 'user'
        }
      });
      videoRef.current.srcObject = stream;
      streamRef.current = stream;
      setIsCameraOn(true);
    } catch (error) {
      console.error('Error accessing camera:', error);
      alert('Tidak dapat mengakses kamera. Pastikan izin kamera diberikan.');
    }
  };

  // Stop camera
  const stopCamera = useCallback(() => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
      streamRef.current = null;
    }
    if (videoRef.current) {
      videoRef.current.srcObject = null;
    }
    setIsCameraOn(false);
    setCurrentPerson(null);
  }, []);

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      stopCamera();
      if (detectionIntervalRef.current) {
        clearInterval(detectionIntervalRef.current);
      }
    };
  }, [stopCamera]);

  // Mark attendance
  const markAttendance = useCallback(async (personName) => {
    const now = new Date();
    const today = now.toISOString().split('T')[0]; // YYYY-MM-DD format
    const time = now.toLocaleTimeString();

    const existingAttendance = attendanceLog.find(log =>
      log.personName === personName && log.date === new Date(today).toDateString()
    );

    if (!existingAttendance) {
      try {
        const result = await ApiService.markAttendance(personName, today, time);
        
        // Update local state
        const newAttendance = {
          id: result.attendance.id,
          personName: result.attendance.personName,
          date: result.attendance.date,
          time: result.attendance.time,
          timestamp: result.attendance.timestamp
        };
        setAttendanceLog(prev => [newAttendance, ...prev]);
        
        console.log(`Attendance marked for ${personName}`);
      } catch (error) {
        console.error('Error marking attendance:', error);
        // Fallback to local storage if API fails
        const newAttendance = {
          personName,
          date: new Date(today).toDateString(),
          time,
          timestamp: now.getTime()
        };
        setAttendanceLog(prev => [...prev, newAttendance]);
      }
    }
  }, [attendanceLog]);

  // Face detection and recognition
  const detectFaces = useCallback(async () => {
    if (!isModelLoaded || !isCameraOn || !videoRef.current || !canvasRef.current) {
      return;
    }

    if (isProcessing) {
      return;
    }

    // Check if video is ready
    if (videoRef.current.readyState !== 4) {
      return;
    }

    setIsProcessing(true);
    try {
      const detections = await faceapi
        .detectAllFaces(videoRef.current, new faceapi.TinyFaceDetectorOptions())
        .withFaceLandmarks()
        .withFaceDescriptors();

      const canvas = canvasRef.current;
      const displaySize = { width: videoRef.current.videoWidth, height: videoRef.current.videoHeight };
      faceapi.matchDimensions(canvas, displaySize);

      const resizedDetections = faceapi.resizeResults(detections, displaySize);
      const ctx = canvas.getContext('2d');
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      if (detections.length > 0) {
        // Draw detections
        faceapi.draw.drawDetections(canvas, resizedDetections);
        faceapi.draw.drawFaceLandmarks(canvas, resizedDetections);

        // Face recognition
        if (registeredFaces.length > 0) {
          const faceMatcher = new faceapi.FaceMatcher(registeredFaces, detectionConfidence);
          const results = detections.map(d => faceMatcher.findBestMatch(d.descriptor));

          results.forEach((result, i) => {
            const box = resizedDetections[i].detection.box;
            const drawBox = new faceapi.draw.DrawBox(box, {
              label: result.toString(),
              lineWidth: 2
            });
            drawBox.draw(canvas);

            if (result.distance < detectionConfidence) {
              const personName = result.label;
              setCurrentPerson(personName);

              // Auto attendance
              if (currentMode === 'attendance' && personName !== 'unknown') {
                markAttendance(personName);
              }
            } else {
              setCurrentPerson(null);
            }
          });
        }
      } else {
        setCurrentPerson(null);
      }
    } catch (error) {
      console.error('Error detecting faces:', error);
    } finally {
      setIsProcessing(false);
    }
  }, [isModelLoaded, isCameraOn, registeredFaces, detectionConfidence, currentMode, isProcessing, markAttendance]);

  // Register new face
  const registerFace = async () => {
    if (!newPersonName.trim() || !isCameraOn) {
      alert('Masukkan nama dan pastikan kamera aktif');
      return;
    }

    if (!isModelLoaded) {
      alert('Model pengenalan wajah belum siap. Tunggu sebentar.');
      return;
    }

    if (registeredFaces.some(face => face.label === newPersonName.trim())) {
      alert('Nama sudah terdaftar. Gunakan nama yang berbeda.');
      return;
    }

    setIsProcessing(true);
    try {
      const detections = await faceapi
        .detectSingleFace(videoRef.current, new faceapi.TinyFaceDetectorOptions())
        .withFaceLandmarks()
        .withFaceDescriptor();

      if (detections) {
        try {
          // Save to database first
          await ApiService.registerFace(newPersonName.trim(), detections.descriptor);
          
          // Update local state
          const newFace = new faceapi.LabeledFaceDescriptors(newPersonName.trim(), [detections.descriptor]);
          setRegisteredFaces(prev => [...prev, newFace]);
          setNewPersonName('');
          alert(`Wajah ${newPersonName.trim()} berhasil didaftarkan!`);
        } catch (error) {
          console.error('Error saving face to database:', error);
          // Fallback to local storage if API fails
          const newFace = new faceapi.LabeledFaceDescriptors(newPersonName.trim(), [detections.descriptor]);
          setRegisteredFaces(prev => [...prev, newFace]);
          setNewPersonName('');
          alert(`Wajah ${newPersonName.trim()} berhasil didaftarkan! (Mode offline)`);
        }
      } else {
        alert('Tidak ada wajah terdeteksi. Pastikan wajah terlihat jelas di kamera.');
      }
    } catch (error) {
      console.error('Error registering face:', error);
      alert('Gagal mendaftarkan wajah. Coba lagi.');
    } finally {
      setIsProcessing(false);
    }
  };

  // Clear attendance log
  const clearAttendanceLog = async () => {
    if (window.confirm('Yakin ingin menghapus semua log kehadiran?')) {
      try {
        await ApiService.clearAttendanceLog();
        setAttendanceLog([]);
        console.log('Attendance log cleared from database');
      } catch (error) {
        console.error('Error clearing attendance log:', error);
        // Fallback to local clear if API fails
        setAttendanceLog([]);
      }
    }
  };

  // Clear registered faces
  const clearRegisteredFaces = async () => {
    if (window.confirm('Yakin ingin menghapus semua wajah terdaftar?')) {
      try {
        await ApiService.clearAllFaces();
        setRegisteredFaces([]);
        setCurrentPerson(null);
        console.log('All faces cleared from database');
      } catch (error) {
        console.error('Error clearing faces:', error);
        // Fallback to local clear if API fails
        setRegisteredFaces([]);
        setCurrentPerson(null);
      }
    }
  };

  // Start detection loop
  useEffect(() => {
    if (detectionIntervalRef.current) {
      clearInterval(detectionIntervalRef.current);
    }

    if (isCameraOn && isModelLoaded) {
      detectionIntervalRef.current = setInterval(detectFaces, 100);
    }

    return () => {
      if (detectionIntervalRef.current) {
        clearInterval(detectionIntervalRef.current);
      }
    };
  }, [isCameraOn, isModelLoaded, detectFaces]);

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Header */}
      <header className="bg-white shadow-lg">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => setShowSidebar(!showSidebar)}
                className="lg:hidden p-2 rounded-lg hover:bg-gray-100"
              >
                <Menu size={24} />
              </button>
              <h1 className="text-2xl font-bold text-blue-600">Face Recognition System</h1>
            </div>
            <div className="flex items-center space-x-2">
              <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                isModelLoaded ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
              }`}>
                {isModelLoaded ? 'Model Ready' : 'Loading Model...'}
              </span>
              {isLoadingData && (
                <span className="px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                  Loading Data...
                </span>
              )}
              {modelLoadingError && (
                <span className="px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                  Model Error
                </span>
              )}
              {apiError && (
                <span className="px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-800">
                  Offline Mode
                </span>
              )}
            </div>
          </div>
        </div>
      </header>

      <div className="flex">
        {/* Sidebar */}
        <div className={`fixed lg:static inset-y-0 left-0 z-50 w-64 bg-white shadow-lg transform ${
          showSidebar ? 'translate-x-0' : '-translate-x-full'
        } lg:translate-x-0 transition-transform duration-300 ease-in-out`}>
          <div className="p-6">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-lg font-semibold">Menu</h2>
              <button
                onClick={() => setShowSidebar(false)}
                className="lg:hidden p-1 rounded hover:bg-gray-100"
              >
                <X size={20} />
              </button>
            </div>

            <nav className="space-y-2">
              <button
                onClick={() => setCurrentMode('detection')}
                className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                  currentMode === 'detection' ? 'bg-blue-100 text-blue-700' : 'hover:bg-gray-100'
                }`}
              >
                <Camera size={20} />
                <span>Deteksi Wajah</span>
              </button>

              <button
                onClick={() => setCurrentMode('registration')}
                className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                  currentMode === 'registration' ? 'bg-blue-100 text-blue-700' : 'hover:bg-gray-100'
                }`}
              >
                <UserPlus size={20} />
                <span>Registrasi Wajah</span>
              </button>

              <button
                onClick={() => setCurrentMode('attendance')}
                className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                  currentMode === 'attendance' ? 'bg-blue-100 text-blue-700' : 'hover:bg-gray-100'
                }`}
              >
                <Clock size={20} />
                <span>Kehadiran</span>
              </button>

              <button
                onClick={() => setCurrentMode('database')}
                className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                  currentMode === 'database' ? 'bg-blue-100 text-blue-700' : 'hover:bg-gray-100'
                }`}
              >
                <Database size={20} />
                <span>Database</span>
              </button>
            </nav>

            <div className="mt-8 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Confidence Threshold
                </label>
                <input
                  type="range"
                  min="0.1"
                  max="1"
                  step="0.1"
                  value={detectionConfidence}
                  onChange={(e) => setDetectionConfidence(parseFloat(e.target.value))}
                  className="w-full"
                />
                <span className="text-sm text-gray-500">{detectionConfidence}</span>
              </div>

              <div className="pt-4 border-t">
                <h3 className="text-sm font-medium text-gray-700 mb-2">Statistics</h3>
                <div className="text-sm text-gray-600 space-y-1">
                  <p>Wajah Terdaftar: {registeredFaces.length}</p>
                  <p>Log Kehadiran: {attendanceLog.length}</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Main Content */}
        <div className="flex-1 p-6">
          <div className="max-w-4xl mx-auto">
            {/* Error Message */}
            {modelLoadingError && (
              <div className="mb-6 bg-red-50 border border-red-200 rounded-lg p-4">
                <div className="flex items-center space-x-2">
                  <AlertCircle size={20} className="text-red-500" />
                  <span className="text-red-700 font-medium">Model Loading Error</span>
                </div>
                <p className="text-red-600 mt-2">{modelLoadingError}</p>
                <button
                  onClick={() => window.location.reload()}
                  className="mt-3 px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg text-sm"
                >
                  Reload Page
                </button>
              </div>
            )}

            {/* Camera Controls */}
            <div className="mb-6 flex flex-wrap gap-4">
              <button
                onClick={isCameraOn ? stopCamera : startCamera}
                disabled={modelLoadingError}
                className={`px-6 py-3 rounded-lg font-medium transition-colors ${
                  isCameraOn
                    ? 'bg-red-500 hover:bg-red-600 text-white'
                    : 'bg-green-500 hover:bg-green-600 text-white'
                } ${modelLoadingError ? 'opacity-50 cursor-not-allowed' : ''}`}
              >
                {isCameraOn ? 'Matikan Kamera' : 'Nyalakan Kamera'}
              </button>

              {currentMode === 'registration' && (
                <div className="flex items-center space-x-4">
                  <input
                    type="text"
                    placeholder="Masukkan nama"
                    value={newPersonName}
                    onChange={(e) => setNewPersonName(e.target.value)}
                    onKeyPress={(e) => {
                      if (e.key === 'Enter' && newPersonName.trim() && !isProcessing && isCameraOn && !modelLoadingError) {
                        registerFace();
                      }
                    }}
                    disabled={modelLoadingError || !isCameraOn}
                    className={`px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent ${
                      modelLoadingError || !isCameraOn ? 'opacity-50 cursor-not-allowed' : ''
                    }`}
                  />
                  <button
                    onClick={registerFace}
                    disabled={isProcessing || !isCameraOn || modelLoadingError || !newPersonName.trim()}
                    className="px-6 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg font-medium disabled:opacity-50"
                  >
                    {isProcessing ? 'Memproses...' : 'Daftarkan Wajah'}
                  </button>
                </div>
              )}
            </div>

            {/* Camera View */}
            <div className="relative bg-black rounded-lg overflow-hidden mb-6">
              <video
                ref={videoRef}
                autoPlay
                muted
                className="w-full h-96 object-cover"
              />
              <canvas
                ref={canvasRef}
                className="absolute top-0 left-0 w-full h-full"
              />

              {currentPerson && (
                <div className="absolute top-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg flex items-center space-x-2">
                  <CheckCircle size={20} />
                  <span>{currentPerson}</span>
                </div>
              )}

              {!isCameraOn && (
                <div className="absolute inset-0 flex items-center justify-center bg-gray-900 bg-opacity-75">
                  <div className="text-center text-white">
                    <Camera size={48} className="mx-auto mb-4" />
                    <p>Kamera belum aktif</p>
                    {modelLoadingError && (
                      <p className="text-red-300 mt-2">Model tidak dapat dimuat</p>
                    )}
                  </div>
                </div>
              )}

              {isCameraOn && !isModelLoaded && !modelLoadingError && (
                <div className="absolute inset-0 flex items-center justify-center bg-gray-900 bg-opacity-75">
                  <div className="text-center text-white">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white mx-auto mb-4"></div>
                    <p>Memuat model pengenalan wajah...</p>
                  </div>
                </div>
              )}
            </div>

            {/* Mode-specific content */}
            {currentMode === 'detection' && (
              <div className="bg-white rounded-lg shadow-lg p-6">
                <h2 className="text-xl font-semibold mb-4">Deteksi Wajah</h2>
                <p className="text-gray-600 mb-4">
                  Sistem akan mendeteksi wajah secara real-time. Wajah yang terdaftar akan ditampilkan dengan nama.
                </p>
                {currentPerson ? (
                  <div className="flex items-center space-x-2 text-green-600">
                    <CheckCircle size={20} />
                    <span>Mengenali: {currentPerson}</span>
                  </div>
                ) : (
                  <div className="flex items-center space-x-2 text-gray-500">
                    <AlertCircle size={20} />
                    <span>Tidak ada wajah dikenali</span>
                  </div>
                )}
              </div>
            )}

            {currentMode === 'registration' && (
              <div className="bg-white rounded-lg shadow-lg p-6">
                <h2 className="text-xl font-semibold mb-4">Registrasi Wajah Baru</h2>
                <p className="text-gray-600 mb-4">
                  Masukkan nama dan klik "Daftarkan Wajah" untuk mendaftarkan wajah baru ke sistem.
                </p>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {registeredFaces.map((face, index) => (
                    <div key={index} className="bg-gray-50 p-4 rounded-lg">
                      <div className="flex items-center space-x-2">
                        <Users size={20} className="text-blue-500" />
                        <span className="font-medium">{face.label}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {currentMode === 'attendance' && (
              <div className="bg-white rounded-lg shadow-lg p-6">
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-xl font-semibold">Log Kehadiran</h2>
                  <button
                    onClick={clearAttendanceLog}
                    className="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg text-sm"
                  >
                    Hapus Log
                  </button>
                </div>
                <p className="text-gray-600 mb-4">
                  Sistem akan otomatis mencatat kehadiran ketika wajah terdaftar terdeteksi.
                </p>
                <div className="space-y-2 max-h-96 overflow-y-auto">
                  {attendanceLog.length === 0 ? (
                    <p className="text-gray-500 text-center py-8">Belum ada log kehadiran</p>
                  ) : (
                    attendanceLog.map((log, index) => (
                      <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                        <div className="flex items-center space-x-3">
                          <CheckCircle size={20} className="text-green-500" />
                          <div>
                            <p className="font-medium">{log.personName}</p>
                            <p className="text-sm text-gray-500">{log.date} - {log.time}</p>
                          </div>
                        </div>
                      </div>
                    ))
                  )}
                </div>
              </div>
            )}

            {currentMode === 'database' && (
              <div className="bg-white rounded-lg shadow-lg p-6">
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-xl font-semibold">Database Wajah</h2>
                  <button
                    onClick={clearRegisteredFaces}
                    className="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg text-sm"
                  >
                    Hapus Semua
                  </button>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {registeredFaces.length === 0 ? (
                    <p className="text-gray-500 text-center py-8 col-span-full">Belum ada wajah terdaftar</p>
                  ) : (
                    registeredFaces.map((face, index) => (
                      <div key={index} className="bg-gray-50 p-4 rounded-lg">
                        <div className="flex items-center justify-between">
                          <div className="flex items-center space-x-2">
                            <Users size={20} className="text-blue-500" />
                            <span className="font-medium">{face.label}</span>
                          </div>
                        </div>
                      </div>
                    ))
                  )}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
