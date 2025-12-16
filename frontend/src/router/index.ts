import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import HomeView from '@/views/HomeView.vue';
import WorkspaceView from '@/views/WorkspaceView.vue';

/**
 * Detect the base path from the current URL.
 * Supports deployments at /dancer/, /bfe2/dancer/, or root /
 */
function getBasePath(): string {
  const path = window.location.pathname;
  // Match paths containing /dancer followed by end, slash, or more path
  const match = path.match(/^(.*\/dancer)(?:\/|$)/);
  if (match) {
    return match[1] + '/';
  }
  return '/';
}

// Log base path for debugging (remove in production if needed)
console.log('DCTap Dancer base path:', getBasePath(), 'from pathname:', window.location.pathname);

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/workspace/:id',
    name: 'workspace',
    component: WorkspaceView,
    props: true
  },
  {
    path: '/workspace/:id/shape/:shapeId',
    name: 'shape',
    component: WorkspaceView,
    props: true
  }
];

const router = createRouter({
  history: createWebHistory(getBasePath()),
  routes
});

export default router;
