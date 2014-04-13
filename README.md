<h2>parallelImageProcessor-1.1.0</h2>

<p>Implentacion del TT para Utem 2013
framework de procesamiento de imagenes en CUDA</p>

<p>Algoritmos seriales implementados</p>
<ul>
<li>transformacion a escala de grises</li>
<li>filtro sobel, con 2 convoluciones en paralelo con cuda</li>
</ul>

<p>Algoritmos cuda Implementados</p>
<ul>
<li>transformacion a escala de grises</li>
<li>convolucion bidimensional</li>
<li>filtro sobel, con 2 convoluciones en paralelo con cuda</li>
<li>blur filter por convolucion bidimensional</li>
<li>sharpener filter por convolucion bidimensional</li>
</ul>

<p>pipeline de procesamiento implementado</p>
<p>en implementacion la ejecucion de los filtros de imagen por cada stage del pipeline</p>

<p>
Proyecto desarrollado en Nsight 5.0 CUDA LINUX, ubuntu 12.10 
</p>
<p>
para la ejecucion
./parallelImageProcessor [ImagenEntrada.ppm] (opcional)[FactorConvolucion]
</p>

<p><em>Release 1.1.0</em></p>