import numpy as np

def calc_MSD(data,track_length):
  msd_allcells = []
  for cell in range(len(data)):
    length = len(data[cell])
    msd_onecell = []
    for lag in range(length):
      x = np.array(data[cell][:,0])
      y = np.array(data[cell][:,1])
      #r = np.sqrt(x**2 + y**2)
      poslags =  (x[lag:] - x[0:length-lag])**2 + (y[lag:] - y[0:length-lag])**2
      msd_onecell.append(np.average(poslags))
    msd_allcells.append(msd_onecell[0:track_length])
  std_err = np.std(msd_allcells,axis=0,ddof=1)/np.sqrt(np.shape(msd_allcells)[0])
  return np.average(msd_allcells,axis=0), std_err


def calc_MSD_sim(data,track_length):
  msd_allcells = []
  for cell in range(len(data)):
    length = len(data[cell])
    msd_onecell = []
    for lag in range(length):
      x = np.array(data[cell]['x'].to_list())
      y = np.array(data[cell]['y'].to_list())
      #r = np.sqrt(x**2 + y**2)
      poslags =  (x[lag:] - x[0:length-lag])**2 + (y[lag:] - y[0:length-lag])**2
      msd_onecell.append(np.average(poslags))
    msd_allcells.append(msd_onecell[0:track_length])
  std_err = np.std(msd_allcells,axis=0,ddof=1)/np.sqrt(np.shape(msd_allcells)[0])
  return np.average(msd_allcells,axis=0), std_err

def calc_MSD_onecell(data,track_length):
  length = len(data)
  msd_onecell = []
  for lag in range(length):
    x = np.array(data['x'].to_list())
    y = np.array(data['y'].to_list())
    #r = np.sqrt(x**2 + y**2)
    poslags =  (x[lag:] - x[0:length-lag])**2 + (y[lag:] - y[0:length-lag])**2
    msd_onecell.append(np.average(poslags))
  return np.array(msd_onecell[:track_length])
