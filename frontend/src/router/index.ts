import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import HomeView from '@/views/HomeView.vue';
import WorkspaceView from '@/views/WorkspaceView.vue';

/**
 * Detect the base path from the current URL.
 * Supports deployments at /dancer/, /bfe2/dancer/, or root /
 */
function getBasePath(): string {
  const path = window.location.pathname;
  // Match paths ending with /dancer or /dancer/
  const match = path.match(/^(.*\/dancer)\/?/);
  if (match) {
    return match[1] + '/';
  }
  return '/';
}

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
