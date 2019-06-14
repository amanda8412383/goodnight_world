#reference https://github.com/Melih-Durmaz/edge_detection/blob/master/edge_detection.py

import os
import re
import sys
import numpy as np


class EdgeDetection:

    def detect_edges(self,img_name):
        file = FileIO()

        img_matrix, size = file.read_pgm_to_matrix(img_name)
        self.ed_filter(img_matrix, size, img_name)



    def ed_filter(self, img_matrix, size, img_name):
        file = FileIO()


        Y = [[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]]
        X = [[-1, -2, -1], [0, 0, 0], [1, 2, 1]]

        img_horizontal = self.convolution(img_matrix,size[0],size[1], Y)
        img_vertical = self.convolution(img_matrix,size[0],size[1], X)

        combined_matrix = self.combine_edge_matrices(img_horizontal, img_vertical)


        threshold = 128
        final_matrix = self.apply_threshold(combined_matrix, threshold)

        new_img_name = "result_"  + img_name

        flat_image = final_matrix.flatten()
        flat_image = flat_image.astype(np.int)
        flat_image = flat_image.tolist()

        flat_image = [str(i) for i in flat_image]
        flat_image = "".join(flat_image)

        file.save_pgm(flat_image, size, new_img_name)


    def combine_edge_matrices(self, img_horizontal, img_vertical):
        #getting a matrix with value of square root of x ^ 2 + y ^ 2
        combined_matrix = np.square(img_horizontal) + np.square(img_vertical)

        combined_matrix = np.sqrt(combined_matrix)
 
        combined_matrix = combined_matrix.astype(np.int)
        return combined_matrix



    def apply_threshold(self,img_matrix, threshold):
        #convert the value as instruction
        img_matrix[img_matrix >= threshold] = threshold
        img_matrix[img_matrix < threshold] = 255
        img_matrix[img_matrix == threshold] = 0

        return img_matrix



    def convolution(self, img_matrix, width, height, filter):
        #to caculate the value of x or y for the whole matrix 
        offset = (int)((len(filter)-1)/2)
        #to avoid the edge

        filter_sum = 0
        filtered_matrix = np.full(img_matrix.shape, 0, dtype=int)
        #set the empty matrix to store value  
        #setting edge to be 0 because it can make sure edge is 255 as in description

        for i in range(offset, width - offset):
            for j in range(offset, height - offset):
                filter_sum = self.apply_filter(img_matrix, i , j, filter, offset)
                filtered_matrix[i - offset][j - offset] = (int)(filter_sum)

        return filtered_matrix

    def apply_filter(self, img_matrix, i, j, filter, offset):
        #based on the filter to calculate value of a single x or y 
        filter_width = len(filter)
        filter_height = len(filter[0])
        filter_sum = 0
        i = i - offset
        j = j - offset

        for k in range(filter_width):
            for l in range(filter_height):
                filter_sum += (filter[k][l]*img_matrix[i + k][j + l])
        return filter_sum





class FileIO:

    #read in the file as instruction
    #return the matrix and its shape 
    def read_pgm_to_matrix(self,file_name):
        with open(file_name, 'r',  encoding="Latin-1") as file:
            magic = file.readline().strip('\n')

            # showing error as instruction
            if magic != 'P2':
                print('error: magic number not found')
                sys.exit()
            
            comment = file.readline()
            size = file.readline().strip('\n').split(' ')
            size = list(filter(None, size))
            size = list(map(int, size))
            maxval = int(file.readline().strip('\n'))

            content = file.read().strip('\n')
            content = re.split(' |\n', content)
            content = list(filter(None, content))

            content =[int(c) for c in content]
            content = np.array(content)
            content = np.reshape(content,(size[0], size[1]))

            return content,size

    def save_pgm(self,flat_image, size, img_name):
        #write the file as form of the input with comment being ignored as the instruction said
        with open(img_name,"w+",  encoding="ascii") as f:
            f.write("P2\n")
            f.write("{} {}\n".format(size[0], size[1]))
            f.write("255\n")
            f.write(flat_image)


# showing error as instruction
if len(sys.argv) > 2:
    print('error: too many arguments')
else:
    EdgeDetection().detect_edges(sys.argv[1])