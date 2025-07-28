import React, { useState, useRef, useEffect } from 'react';
import { Camera, Users, Clock, UserPlus, BarChart3, Menu, X } from 'lucide-react';

const FaceAttendanceApp = () => {
  // States
  const [activeTab, setActiveTab] = useState('attendance');
  const [employees, setEmployees] = useState([]);
  const [attendanceRecords, setAttendanceRecords] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [message, setMessage] = useState('');
  const [isCameraOn, setIsCameraOn] = useState(false);
  const [faceApiLoaded, setFaceApiLoaded] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(false);

  // Refs
  const videoRef = useRef(null);
  const canvasRef = useRef(null);
  const streamRef = useRef(null);

  // Employee form states
  const [newEmployee, setNewEmployee] = useState({
    name: '',
    id: '',
    department: ''
  });
  const [selectedPhoto, setSelectedPhoto] = useState(null);
  const [photoPreview, setPhotoPreview] = useState('');

  // Load face-api models
  useEffect(() => {
    const loadFaceAPI = async () => {
      try {
        // In a real implementation, you would load actual face-api.js models
        // For this demo, we'll simulate the loading
        await new Promise(resolve => setTimeout(resolve, 2000));
        setFaceApiLoaded(true);
        showMessage('Face recognition models loaded successfully!', 'success');
      } catch (error) {
        showMessage('Failed to load face recognition models', 'error');
      }
    };
    loadFaceAPI();
  }, []);

  // Load data from localStorage on component mount
  useEffect(() => {
    const savedEmployees = localStorage.getItem('employees');
    const savedAttendance = localStorage.getItem('attendanceRecords');
    
    if (savedEmployees) {
      setEmployees(JSON.parse(savedEmployees));
    }
    if (savedAttendance) {
      setAttendanceRecords(JSON.parse(savedAttendance));
    }
  }, []);

  // Save data to localStorage whenever it changes
  useEffect(() => {
    localStorage.setItem('employees', JSON.stringify(employees));
  }, [employees]);

  useEffect(() => {
    localStorage.setItem('attendanceRecords', JSON.stringify(attendanceRecords));
  }, [attendanceRecords]);

  const showMessage = (text, type = 'info') => {
    setMessage({ text, type });
    setTimeout(() => setMessage(''), 5000);
  };

  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ 
        video: { width: 640, height: 480 }
      });
      
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        streamRef.current = stream;
        setIsCameraOn(true);
      }
    } catch (error) {
      showMessage('Unable to access camera. Please check permissions.', 'error');
    }
  };

  const stopCamera = () => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
      streamRef.current = null;
    }
    setIsCameraOn(false);
  };

  const capturePhoto = () => {
    if (!videoRef.current || !canvasRef.current) return null;

    const canvas = canvasRef.current;
    const video = videoRef.current;
    const context = canvas.getContext('2d');

    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    context.drawImage(video, 0, 0);

    return canvas.toDataURL('image/jpeg');
  };

  const simulateFaceRecognition = async (imageData) => {
    // Simulate face recognition processing
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // For demo purposes, randomly recognize an employee
    if (employees.length > 0 && Math.random() > 0.3) {
      const randomEmployee = employees[Math.floor(Math.random() * employees.length)];
      return randomEmployee;
    }
    return null;
  };

  const handleAttendanceScan = async () => {
    if (!faceApiLoaded) {
      showMessage('Face recognition models are still loading...', 'warning');
      return;
    }

    if (!isCameraOn) {
      showMessage('Please start the camera first', 'warning');
      return;
    }

    setIsLoading(true);
    try {
      const imageData = capturePhoto();
      if (!imageData) {
        showMessage('Failed to capture image', 'error');
        return;
      }

      const recognizedEmployee = await simulateFaceRecognition(imageData);
      
      if (recognizedEmployee) {
        const now = new Date();
        const attendanceRecord = {
          id: Date.now(),
          employeeId: recognizedEmployee.id,
          employeeName: recognizedEmployee.name,
          timestamp: now.toISOString(),
          date: now.toDateString(),
          time: now.toLocaleTimeString(),
          type: 'check-in'
        };

        setAttendanceRecords(prev => [attendanceRecord, ...prev]);
        showMessage(`Attendance recorded for ${recognizedEmployee.name}`, 'success');
      } else {
        showMessage('Face not recognized. Please contact admin.', 'error');
      }
    } catch (error) {
      showMessage('Error during face recognition', 'error');
    } finally {
      setIsLoading(false);
    }
  };

  const handlePhotoSelect = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedPhoto(file);
      const reader = new FileReader();
      reader.onload = (e) => setPhotoPreview(e.target.result);
      reader.readAsDataURL(file);
    }
  };

  const handleAddEmployee = async () => {
    if (!newEmployee.name || !newEmployee.id || !selectedPhoto) {
      showMessage('Please fill all fields and select a photo', 'warning');
      return;
    }

    if (employees.some(emp => emp.id === newEmployee.id)) {
      showMessage('Employee ID already exists', 'error');
      return;
    }

    setIsLoading(true);
    try {
      // Simulate face encoding process
      await new Promise(resolve => setTimeout(resolve, 1500));

      const employee = {
        ...newEmployee,
        photo: photoPreview,
        createdAt: new Date().toISOString(),
        faceDescriptor: 'simulated_face_encoding_' + Date.now()
      };

      setEmployees(prev => [...prev, employee]);
      setNewEmployee({ name: '', id: '', department: '' });
      setSelectedPhoto(null);
      setPhotoPreview('');
      showMessage(`Employee ${employee.name} added successfully!`, 'success');
    } catch (error) {
      showMessage('Failed to add employee', 'error');
    } finally {
      setIsLoading(false);
    }
  };

  const deleteEmployee = (employeeId) => {
    setEmployees(prev => prev.filter(emp => emp.id !== employeeId));
    showMessage('Employee deleted successfully', 'success');
  };

  const getTodayAttendance = () => {
    const today = new Date().toDateString();
    return attendanceRecords.filter(record => record.date === today);
  };

  const getAttendanceStats = () => {
    const today = getTodayAttendance();
    const thisMonth = attendanceRecords.filter(record => {
      const recordDate = new Date(record.timestamp);
      const now = new Date();
      return recordDate.getMonth() === now.getMonth() && 
             recordDate.getFullYear() === now.getFullYear();
    });

    return {
      todayCount: today.length,
      monthlyCount: thisMonth.length,
      totalEmployees: employees.length,
      attendanceRate: employees.length > 0 ? Math.round((today.length / employees.length) * 100) : 0
    };
  };

  const stats = getAttendanceStats();

  const Sidebar = () => (
    <div className={`fixed inset-y-0 left-0 z-50 w-64 bg-white shadow-lg transform ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'} transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-0`}>
      <div className="flex items-center justify-between h-16 px-6 bg-blue-600">
        <h1 className="text-xl font-bold text-white">Face Attendance</h1>
        <button
          onClick={() => setSidebarOpen(false)}
          className="lg:hidden text-white"
        >
          <X size={24} />
        </button>
      </div>
      
      <nav className="mt-8">
        <div className="px-6 space-y-2">
          <button
            onClick={() => {setActiveTab('attendance'); setSidebarOpen(false);}}
            className={`w-full flex items-center px-4 py-3 text-left rounded-lg transition-colors ${
              activeTab === 'attendance' ? 'bg-blue-100 text-blue-700' : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <Clock className="mr-3" size={20} />
            Attendance
          </button>
          
          <button
            onClick={() => {setActiveTab('employees'); setSidebarOpen(false);}}
            className={`w-full flex items-center px-4 py-3 text-left rounded-lg transition-colors ${
              activeTab === 'employees' ? 'bg-blue-100 text-blue-700' : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <Users className="mr-3" size={20} />
            Employees
          </button>
          
          <button
            onClick={() => {setActiveTab('reports'); setSidebarOpen(false);}}
            className={`w-full flex items-center px-4 py-3 text-left rounded-lg transition-colors ${
              activeTab === 'reports' ? 'bg-blue-100 text-blue-700' : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <BarChart3 className="mr-3" size={20} />
            Reports
          </button>
        </div>
      </nav>
    </div>
  );

  const AttendanceTab = () => (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg p-6 shadow-sm border">
          <h3 className="text-lg font-semibold mb-4 flex items-center">
            <Camera className="mr-2" size={20} />
            Face Recognition Scanner
          </h3>
          
          <div className="space-y-4">
            <div className="relative bg-gray-100 rounded-lg overflow-hidden" style={{height: '300px'}}>
              <video
                ref={videoRef}
                autoPlay
                muted
                playsInline
                className={`w-full h-full object-cover ${!isCameraOn ? 'hidden' : ''}`}
              />
              <canvas ref={canvasRef} className="hidden" />
              
              {!isCameraOn && (
                <div className="flex items-center justify-center h-full text-gray-500">
                  <div className="text-center">
                    <Camera size={48} className="mx-auto mb-2 opacity-50" />
                    <p>Camera is off</p>
                  </div>
                </div>
              )}
              
              {isLoading && (
                <div className="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                  <div className="text-white text-center">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-white mx-auto mb-2"></div>
                    <p>Processing...</p>
                  </div>
                </div>
              )}
            </div>
            
            <div className="flex space-x-2">
              <button
                onClick={isCameraOn ? stopCamera : startCamera}
                className={`flex-1 py-2 px-4 rounded-lg font-medium ${
                  isCameraOn 
                    ? 'bg-red-500 hover:bg-red-600 text-white' 
                    : 'bg-blue-500 hover:bg-blue-600 text-white'
                }`}
              >
                {isCameraOn ? 'Stop Camera' : 'Start Camera'}
              </button>
              
              <button
                onClick={handleAttendanceScan}
                disabled={!isCameraOn || isLoading || !faceApiLoaded}
                className="flex-1 py-2 px-4 bg-green-500 text-white rounded-lg font-medium hover:bg-green-600 disabled:bg-gray-300 disabled:cursor-not-allowed"
              >
                {isLoading ? 'Scanning...' : 'Scan Face'}
              </button>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg p-6 shadow-sm border">
          <h3 className="text-lg font-semibold mb-4">Today's Attendance</h3>
          <div className="space-y-3 max-h-80 overflow-y-auto">
            {getTodayAttendance().map((record) => (
              <div key={record.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="font-medium">{record.employeeName}</p>
                  <p className="text-sm text-gray-500">ID: {record.employeeId}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm font-medium">{record.time}</p>
                  <span className="inline-block px-2 py-1 text-xs bg-green-100 text-green-800 rounded">
                    {record.type}
                  </span>
                </div>
              </div>
            ))}
            
            {getTodayAttendance().length === 0 && (
              <p className="text-gray-500 text-center py-8">No attendance records for today</p>
            )}
          </div>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white p-4 rounded-lg shadow-sm border">
          <div className="flex items-center">
            <div className="p-2 bg-blue-100 rounded-lg">
              <Users className="text-blue-600" size={20} />
            </div>
            <div className="ml-3">
              <p className="text-sm text-gray-500">Total Employees</p>
              <p className="text-xl font-semibold">{stats.totalEmployees}</p>
            </div>
          </div>
        </div>
        
        <div className="bg-white p-4 rounded-lg shadow-sm border">
          <div className="flex items-center">
            <div className="p-2 bg-green-100 rounded-lg">
              <Clock className="text-green-600" size={20} />
            </div>
            <div className="ml-3">
              <p className="text-sm text-gray-500">Today Present</p>
              <p className="text-xl font-semibold">{stats.todayCount}</p>
            </div>
          </div>
        </div>
        
        <div className="bg-white p-4 rounded-lg shadow-sm border">
          <div className="flex items-center">
            <div className="p-2 bg-purple-100 rounded-lg">
              <BarChart3 className="text-purple-600" size={20} />
            </div>
            <div className="ml-3">
              <p className="text-sm text-gray-500">Attendance Rate</p>
              <p className="text-xl font-semibold">{stats.attendanceRate}%</p>
            </div>
          </div>
        </div>
        
        <div className="bg-white p-4 rounded-lg shadow-sm border">
          <div className="flex items-center">
            <div className="p-2 bg-orange-100 rounded-lg">
              <Clock className="text-orange-600" size={20} />
            </div>
            <div className="ml-3">
              <p className="text-sm text-gray-500">This Month</p>
              <p className="text-xl font-semibold">{stats.monthlyCount}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  const EmployeesTab = () => (
    <div className="space-y-6">
      <div className="bg-white rounded-lg p-6 shadow-sm border">
        <h3 className="text-lg font-semibold mb-4 flex items-center">
          <UserPlus className="mr-2" size={20} />
          Add New Employee
        </h3>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Employee Name
              </label>
              <input
                type="text"
                value={newEmployee.name}
                onChange={(e) => setNewEmployee(prev => ({...prev, name: e.target.value}))}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Enter employee name"
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Employee ID
              </label>
              <input
                type="text"
                value={newEmployee.id}
                onChange={(e) => setNewEmployee(prev => ({...prev, id: e.target.value}))}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Enter employee ID"
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Department
              </label>
              <input
                type="text"
                value={newEmployee.department}
                onChange={(e) => setNewEmployee(prev => ({...prev, department: e.target.value}))}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Enter department"
              />
            </div>
          </div>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Employee Photo
              </label>
              <input
                type="file"
                accept="image/*"
                onChange={handlePhotoSelect}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            
            {photoPreview && (
              <div className="border-2 border-dashed border-gray-300 rounded-lg p-4">
                <img
                  src={photoPreview}
                  alt="Preview"
                  className="w-32 h-32 object-cover rounded-lg mx-auto"
                />
              </div>
            )}
            
            <button
              onClick={handleAddEmployee}
              disabled={isLoading}
              className="w-full py-2 px-4 bg-blue-500 text-white rounded-lg font-medium hover:bg-blue-600 disabled:bg-gray-300 disabled:cursor-not-allowed"
            >
              {isLoading ? 'Adding Employee...' : 'Add Employee'}
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg p-6 shadow-sm border">
        <h3 className="text-lg font-semibold mb-4">Employee List</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {employees.map((employee) => (
            <div key={employee.id} className="border rounded-lg p-4 hover:shadow-md transition-shadow">
              <div className="flex items-center space-x-3">
                <img
                  src={employee.photo}
                  alt={employee.name}
                  className="w-12 h-12 rounded-full object-cover"
                />
                <div className="flex-1">
                  <h4 className="font-medium">{employee.name}</h4>
                  <p className="text-sm text-gray-500">ID: {employee.id}</p>
                  <p className="text-sm text-gray-500">{employee.department}</p>
                </div>
                <button
                  onClick={() => deleteEmployee(employee.id)}
                  className="text-red-500 hover:text-red-700 text-sm"
                >
                  Delete
                </button>
              </div>
            </div>
          ))}
          
          {employees.length === 0 && (
            <div className="col-span-full text-center py-8 text-gray-500">
              No employees added yet
            </div>
          )}
        </div>
      </div>
    </div>
  );

  const ReportsTab = () => (
    <div className="space-y-6">
      <div className="bg-white rounded-lg p-6 shadow-sm border">
        <h3 className="text-lg font-semibold mb-4">Attendance Reports</h3>
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Employee
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Date
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Time
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Type
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {attendanceRecords.slice(0, 50).map((record) => (
                <tr key={record.id}>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div>
                      <div className="text-sm font-medium text-gray-900">
                        {record.employeeName}
                      </div>
                      <div className="text-sm text-gray-500">
                        ID: {record.employeeId}
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {record.date}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {record.time}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">
                      {record.type}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          
          {attendanceRecords.length === 0 && (
            <div className="text-center py-8 text-gray-500">
              No attendance records found
            </div>
          )}
        </div>
      </div>
    </div>
  );

  return (
    <div className="flex h-screen bg-gray-50">
      <Sidebar />
      
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Header */}
        <header className="bg-white shadow-sm border-b px-6 py-4 lg:hidden">
          <div className="flex items-center justify-between">
            <h1 className="text-xl font-semibold">Face Attendance System</h1>
            <button
              onClick={() => setSidebarOpen(true)}
              className="text-gray-600"
            >
              <Menu size={24} />
            </button>
          </div>
        </header>

        {/* Main Content */}
        <main className="flex-1 overflow-y-auto p-6">
          {/* Message Alert */}
          {message && (
            <div className={`mb-4 p-4 rounded-lg ${
              message.type === 'success' ? 'bg-green-100 text-green-700' :
              message.type === 'error' ? 'bg-red-100 text-red-700' :
              message.type === 'warning' ? 'bg-yellow-100 text-yellow-700' :
              'bg-blue-100 text-blue-700'
            }`}>
              {message.text}
            </div>
          )}

          {/* Face API Loading Status */}
          {!faceApiLoaded && (
            <div className="mb-4 p-4 bg-blue-100 text-blue-700 rounded-lg flex items-center">
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-blue-700 mr-2"></div>
              Loading face recognition models...
            </div>
          )}

          {/* Tab Content */}
          {activeTab === 'attendance' && <AttendanceTab />}
          {activeTab === 'employees' && <EmployeesTab />}
          {activeTab === 'reports' && <ReportsTab />}
        </main>
      </div>

      {/* Mobile Sidebar Overlay */}
      {sidebarOpen && (
        <div 
          className="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}
    </div>
  );
};

export default FaceAttendanceApp;
