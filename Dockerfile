FROM jupyter/minimal-notebook
USER root
# Add config to Jupyter notebook
COPY jupyter/jupyter_notebook_config.py /home/jovyan/.jupyter/
RUN chmod -R 777 /home/jovyan/

USER $NB_USER
# Install Python requirements
COPY poetry.lock pyproject.toml /home/jovyan/
WORKDIR /home/jovyan
RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev
# Custom styling
RUN mkdir -p /home/jovyan/.jupyter/custom
COPY custom/custom.css /home/jovyan/.jupyter/custom/
# NB extensions
RUN jupyter contrib nbextension install --user
RUN jupyter nbextensions_configurator enable --user
# Run the notebook
CMD ["/opt/conda/bin/jupyter", "notebook"]
