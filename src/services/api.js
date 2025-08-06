// API service for face recognition backend

const API_BASE_URL = process.env.REACT_APP_API_URL || '/api';

class ApiService {
  async request(endpoint, options = {}) {
    const url = `${API_BASE_URL}${endpoint}`;
    const config = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || `HTTP error! status: ${response.status}`);
      }

      return data;
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  // Face-related API calls
  async getAllFaces() {
    return this.request('/faces');
  }

  async registerFace(label, descriptors) {
    return this.request('/faces', {
      method: 'POST',
      body: JSON.stringify({ label, descriptors }),
    });
  }

  async deleteFace(label) {
    return this.request(`/faces/${encodeURIComponent(label)}`, {
      method: 'DELETE',
    });
  }

  async clearAllFaces() {
    return this.request('/faces', {
      method: 'DELETE',
    });
  }

  // Attendance-related API calls
  async getAttendanceLog() {
    return this.request('/attendance');
  }

  async markAttendance(personName, date, time) {
    return this.request('/attendance', {
      method: 'POST',
      body: JSON.stringify({ personName, date, time }),
    });
  }

  async clearAttendanceLog() {
    return this.request('/attendance', {
      method: 'DELETE',
    });
  }

  // Health check
  async healthCheck() {
    return this.request('/health');
  }
}

export default new ApiService();