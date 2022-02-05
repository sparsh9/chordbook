import { createRouter, createWebHistory } from '@ionic/vue-router'
import TabsView from '@/views/TabsView.vue'

const routes = [
  {
    path: '/',
    redirect: '/discover'
  },
  {
    path: '/tabs',
    component: TabsView,
    children: [
      {
        path: '/discover',
        name: 'discover',
        props: route => ({ searchParams: route.query }),
        component: () => import('@/views/DiscoverView.vue'),
        meta: { selected: 'discover' }
      },
      {
        path: '/artists',
        name: 'artists',
        component: () => import('@/views/ArtistListView.vue'),
        meta: { selected: 'artists' }
      },
      {
        path: '/artists/:id',
        name: 'artist',
        props: true,
        component: () => import('@/views/ArtistView.vue')
      },
      {
        path: '/albums/:id',
        name: 'album',
        props: true,
        component: () => import('@/views/AlbumView.vue')
      },
      {
        path: '/tracks/:id',
        name: 'track',
        props: true,
        component: () => import('@/views/TrackView.vue')
      },
      {
        path: '/genres/:id',
        name: 'genre',
        props: true,
        component: () => import('@/views/GenreView.vue'),
        meta: { selected: 'discover' }
      },
      {
        path: '/songsheets',
        name: 'songsheets',
        component: () => import('@/views/SongsheetListView.vue'),
        meta: { selected: 'songs' }
      }
    ]
  },
  {
    path: '/songsheets/new',
    name: 'songsheet.new',
    component: () => import('@/views/SongsheetEditorView.vue'),
    meta: { selected: 'songs' }
  },
  {
    path: '/songsheets/:id/edit',
    name: 'songsheet.edit',
    props: true,
    component: () => import('@/views/SongsheetEditorView.vue'),
    meta: { selected: 'songs' }
  },
  {
    path: '/songsheets/:id',
    name: 'songsheet',
    props: true,
    component: () => import('@/views/SongsheetView.vue'),
    meta: { selected: 'songs' }
  },
  {
    path: '/tuner',
    name: 'tuner',
    component: () => import('@/views/TunerView.vue')
  },
  {
    path: '/:path(.*)*',
    name: '404',
    component: () => import('@/views/NotFound.vue'),
    beforeEnter (to, from, next) {
      if (to.params.path || !to.redirectedFrom) {
        next()
      } else {
        console.log(to.redirectedFrom)
        // Preserve path of View that redirected here
        next({
          name: '404',
          replace: true,
          // Convert previous path into array
          params: { path: to.redirectedFrom.path.slice(1).split('/') },
          query: to.redirectedFrom.query,
          hash: to.redirectedFrom.hash
        })
      }
    }
  }
]

export default createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})
