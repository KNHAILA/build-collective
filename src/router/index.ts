import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import store from '@/store'
import SignIn from '@/views/SignIn.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'SignIn',
    component: SignIn,
  },
  {
    path: '/account',
    name: 'Account',
    component: () => import('@/views/Account.vue'),
  },
  {
    path: '/open-entreprise',
    name: 'OpenEntreprise',
    component: () => import('@/views/OpenEntreprise.vue'),
  },
  {
    path: '/entreprise_information',
    name: 'EnterpriseInformation',
    component: () => import('@/views/EnterpriseInformation.vue'),
  },
  {
    path: '/create-project',
    name: 'CreateProject',
    component: () => import('@/views/CreateProject.vue'),
  },
  {
    path: '/view-projects',
    name: 'ViewAllProjects',
    component: () => import('@/views/ViewAllProjects.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, _from, next) => {
  if (to.name !== 'SignIn' && !store.state.account.address) {
    next({ name: 'SignIn' })
  } else {
    next()
  }
})

export default router
