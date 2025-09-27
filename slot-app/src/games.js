export const games = [
  { name: 'Lucky Cherry', image: '/images/lucky-cherry.png' },
  { name: 'Golden Lemon', image: '/images/golden-lemon.png' },
  { name: 'Bell Star', image: '/images/bell-star.png' },
  { name: 'Emerald Clover', image: '/images/emerald-clover.png' },
  { name: 'Diamond Spin', image: '/images/diamond-spin.png' },
  { name: 'Super Seven', image: '/images/super-seven.png' },
  { name: 'Mega Bar', image: '/images/mega-bar.png' },
  { name: 'Jackpot King', image: '/images/jackpot-king.png' },
  ...Array.from({ length: 92 }, (_, i) => ({
    name: `Game ${i + 9}`,
    image: '/images/placeholder.png'
  }))
];