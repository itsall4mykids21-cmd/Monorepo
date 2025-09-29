-- Run this script in your Supabase SQL editor to set up the database
-- This creates the necessary tables for the slot game app

-- Enable Row Level Security (RLS) on relevant tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.game_events ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles table
CREATE POLICY "Users can view their own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create policies for scores table  
CREATE POLICY "Users can view public scores" ON public.scores
  FOR SELECT USING (is_public = true);

CREATE POLICY "Users can view their own scores" ON public.scores
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own scores" ON public.scores
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Create policies for game_events table
CREATE POLICY "Users can view their own game events" ON public.game_events
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own game events" ON public.game_events
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Insert a default tenant for the slot game
INSERT INTO public.tenants (id, name) 
VALUES ('00000000-0000-0000-0000-000000000000', 'Default Tenant')
ON CONFLICT (id) DO NOTHING;

-- Insert a default slot machine game
INSERT INTO public.games (
  slug, 
  name, 
  provider, 
  rtp, 
  volatility, 
  image_url, 
  description
) VALUES (
  'slot-machine-1',
  'Classic Slot Machine',
  'House',
  0.96,
  'medium',
  'https://via.placeholder.com/300x200?text=Slot+Machine',
  'A classic 3-reel slot machine with fruit symbols and special bonuses'
)
ON CONFLICT (slug) DO NOTHING;

-- Function to automatically create profile when user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, display_name)
  VALUES (new.id, new.email, new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();