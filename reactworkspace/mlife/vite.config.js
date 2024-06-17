import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  // server: {
  //   proxy: {
  //     '/api': {
  //       target: process.env.REACT_APP_BACKEND_URL || 'http://3.36.235.167:8080',
  //       changeOrigin: true,
  //       secure: false
  //     }
  //   }
  // }
})
