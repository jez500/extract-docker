module.exports = {
  apps: [
    {
      name: 'extract',
      script: 'app/server.js',
      instances: process.env.INSTANCES || 'max',
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3000,
      },
      max_memory_restart: '500M',
      watch: false,
      ignore_watch: ['node_modules', 'logs'],
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      error_file: '/tmp/logs/extract-error.log',
      out_file: '/tmp/logs/extract-out.log',
    },
  ],
};
