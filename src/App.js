import React, { useState, useEffect, useRef } from 'react';
import * as faceapi from 'face-api.js';
import { Camera, Users, Settings, LogOut, Menu, X, CheckCircle, AlertCircle, UserPlus, Clock, Database } from 'lucide-react';

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

  const videoRef = useRef();
  const canvasRef = useRef();
  const streamRef = useRef();

  // Load face-api models from CDN
  useEffect(() => {
    const loadModels = async () => {
      try {
        const MODEL_URL = 'https://justadudewhohacks.github.io/face-api.js/models';

        await Promise.all([
          faceapi.nets.tinyFaceDetector.loadFromUri(MODEL_URL),
          faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL),
          faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL),
          faceapi.nets.faceExpressionNet.loadFromUri(MODEL_URL)
        ]);
        setIsModelLoaded(true);
        console.log('Models loaded successfully');
      } catch (error) {
        console.error('Error loading models:', error);
      }
    };

    loadModels();
  }, []);

  // Start camera
  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ video: true });
      videoRef.current.srcObject = stream;
      streamRef.current = stream;
      setIsCameraOn(true);
    } catch (error) {
      console.error('Error accessing camera:', error);
      alert('Tidak dapat mengakses kamera. Pastikan izin kamera diberikan.');
    }
  };

  // Stop camera
  const stopCamera = () => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
      streamRef.current = null;
    }
    setIsCameraOn(false);
  };

  // Face detection and recognition
  const detectFaces = async () => {
    if (!isModelLoaded || !isCameraOn) {return;}

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
      canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);

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
  };

  // Register new face
  const registerFace = async () => {
    if (!newPersonName.trim() || !isCameraOn) {
      alert('Masukkan nama dan pastikan kamera aktif');
      return;
    }

    setIsProcessing(true);
    try {
      const detections = await faceapi
        .detectSingleFace(videoRef.current, new faceapi.TinyFaceDetectorOptions())
        .withFaceLandmarks()
        .withFaceDescriptor();

      if (detections) {
        const newFace = new faceapi.LabeledFaceDescriptors(newPersonName, [detections.descriptor]);
        setRegisteredFaces(prev => [...prev, newFace]);
        setNewPersonName('');
        alert(`Wajah ${newPersonName} berhasil didaftarkan!`);
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

  // Mark attendance
  const markAttendance = (personName) => {
    const now = new Date();
    const today = now.toDateString();
    const time = now.toLocaleTimeString();

    const existingAttendance = attendanceLog.find(log =>
      log.personName === personName && log.date === today
    );

    if (!existingAttendance) {
      const newAttendance = {
        personName,
        date: today,
        time,
        timestamp: now.getTime()
      };
      setAttendanceLog(prev => [...prev, newAttendance]);
    }
  };

  // Clear attendance log
  const clearAttendanceLog = () => {
    if (window.confirm('Yakin ingin menghapus semua log kehadiran?')) {
      setAttendanceLog([]);
    }
  };

  // Clear registered faces
  const clearRegisteredFaces = () => {
    if (window.confirm('Yakin ingin menghapus semua wajah terdaftar?')) {
      setRegisteredFaces([]);
    }
  };

  // Start detection loop
  useEffect(() => {
    let interval;
    if (isCameraOn && isModelLoaded) {
      interval = setInterval(detectFaces, 100);
    }
    return () => {
      if (interval) {clearInterval(interval);}
    };
  }, [isCameraOn, isModelLoaded, registeredFaces, detectionConfidence]);

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
            <div className="flex items-center space-x-4">
              <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                isModelLoaded ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
              }`}>
                {isModelLoaded ? 'Model Ready' : 'Loading Model...'}
              </span>
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
            {/* Camera Controls */}
            <div className="mb-6 flex flex-wrap gap-4">
              <button
                onClick={isCameraOn ? stopCamera : startCamera}
                className={`px-6 py-3 rounded-lg font-medium transition-colors ${
                  isCameraOn
                    ? 'bg-red-500 hover:bg-red-600 text-white'
                    : 'bg-green-500 hover:bg-green-600 text-white'
                }`}
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
                    className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                  <button
                    onClick={registerFace}
                    disabled={isProcessing || !isCameraOn}
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
